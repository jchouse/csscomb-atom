'use babel';

import {CompositeDisposable} from 'atom';
import Comb from 'csscomb';
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
        }
    },

    getSettingsConfig () {
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

    activate (state) {
        this.subscriptions = new CompositeDisposable();

        this.subscriptions.add(atom.commands.add('atom-workspace', {
          'css-comb:comb': () => this.comb()
        }));
    },

    comb () {
        var comb, config, filePath;
        filePath = atom.workspace.getActivePaneItem().getPath();
        config = this.getSettingsConfig();
        if (config instanceof Error) {
            return atom.notifications.addError(config.message);
        } else {
            comb = new Comb(config);
            return comb.processPath(filePath).then(function() {
                return atom.notifications.addSuccess('Css combed!');
            });
        }
    }
};
