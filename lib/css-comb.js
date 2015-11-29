'use babel';

import {CompositeDisposable} from 'atom';
import Comb from 'csscomb';
import path from 'path';

export default {
    config: {
        projectConfigs: {
            title: 'Use project config',
            description: '.csscomb.json for example. Relative to the project directory. The details below.',
            default: '',
            type: 'string'
        },
        readyMadeConfigs: {
            title: 'Ready made configs',
            description: 'Used when you do not specify a project file. The details below.',
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
            readyMadeConfigs = atom.config.get('atom-css-comb.readyMadeConfigs');

        if (projectConfigs) {
            optionsFilePath = path.join(projectPath, projectConfigs);
            try {
                return require(optionsFilePath);
            } catch (_error) {
                error = _error;
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
