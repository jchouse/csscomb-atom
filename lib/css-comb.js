'use babel';

import {CompositeDisposable, Task} from 'atom';
import path from 'path';

export default {
    config: {
        projectConfigs: {
            title: 'Use project config',
            description: 'Relative to the project directory. Example: `.csscomb.json` or `configs/.csscomb.json`. Leave blank if you want to use the following setting',
            default: '',
            type: 'string'
        },
        commonConfigs: {
            title: 'Use common config',
            description: 'Put here a full path to your config. Example: `/Users/jchouse/propjects/.csscomb.json`. Leave blank if you want to use the following setting',
            default: '',
            type: 'string'
        },
        readyMadeConfigs: {
            title: 'Ready made configs',
            description: 'Used when you do not specify a project or common file. The details below.',
            type: 'string',
            default: 'yandex',
            enum: ['yandex', 'csscomb', 'zen']
        },
        runOnSave: {
            title: 'Run on save',
            description: 'Format your files everytime you save',
            default: false,
            type: 'boolean'
        }
    },

    subscriptions: new CompositeDisposable(),

    getSettingsConfig() {
        var cssCombPackage = atom.packages.getLoadedPackage('atom-css-comb'),
            error,
            optionsFilePath,
            projectConfigs = atom.config.get('atom-css-comb.projectConfigs'),
            projectPath = atom.project.getPaths()[0],
            commonConfigs = atom.config.get('atom-css-comb.commonConfigs'),
            readyMadeConfigs = atom.config.get('atom-css-comb.readyMadeConfigs');

        if (projectConfigs) {
            optionsFilePath = path.join(projectPath, projectConfigs);
            try {
                return require(optionsFilePath);
            } catch (error) {
                return error;
            }
        } else if (commonConfigs) {
            try {
                return require(commonConfigs);
            } catch (error) {
                return error;
            }
        } else {
            return readyMadeConfigs || 'yandex';
        }
    },

    activate() {
        this.subscriptions.add(atom.commands.add('atom-workspace', {
          'css-comb:comb': () => this.comb()
        }));

        this.observeSave();
    },

    destroy() {
        this.subscriptions.dispose();
    },

    observeSave () {
        this.subscriptions.add(atom.workspace.observeTextEditors(editor => {
            this.subscriptions.add(editor.getBuffer().onWillSave(() => {
                const runOnSave = atom.config.get('atom-css-comb.runOnSave'),
                    syntax = this._getSytax(),
                    name = atom.workspace.getActiveTextEditor().getGrammar().name;

                if (!(syntax instanceof Error) && runOnSave && name !== 'HTML') {
                    this.comb();
                }
            }));
        }));
    },

    _getSytax() {
        var syntax = atom.workspace.getActiveTextEditor().getGrammar().name.toLowerCase();

        if (['css', 'less', 'sass', 'scss'].includes(syntax)) {
            return syntax;
        } else if (['html', 'postcss'].includes(syntax)) {
            return 'css';
        } else {
            return new Error();
        }
    },

    _getSelectedText() {
        return atom.workspace.getActiveTextEditor().getSelectedText();
    },

    _getText() {
        return atom.workspace.getActiveTextEditor().getText();
    },

    comb() {
        var config = this.getSettingsConfig(),
            selectedText = this._getSelectedText(),
            syntax = this._getSytax();

        if (config instanceof Error) {
            return atom.notifications.addError(config.message);
        } else if (syntax instanceof Error) {
            return atom.notifications.addError('Not supported syntax');
        } else {
            const _name = atom.workspace.getActiveTextEditor().getGrammar().name,
                activePane = atom.workspace.getActivePaneItem();

            if (!selectedText && syntax === 'css' && _name === 'HTML') {
                atom.notifications.addError('Please select the css for combing.');
                return;
            }

            const task = Task.once(`${__dirname}/comb-task.js`,
                config,
                syntax,
                selectedText || this._getText(),
                () => console.log('csscomb: Comb done'));

            task.on('comb-text-success',
                result => {
                    if (selectedText !== '') {
                        activePane.setTextInBufferRange(activePane.getSelectedBufferRange(), result);
                    } else {
                        atom.workspace.getActivePaneItem().setText(result);
                    }
                });

            task.on('comb-text-error',
                error => atom.notifications.addError(error.stack));
        }
    }
};
