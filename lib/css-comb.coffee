Comb = require 'csscomb'
path = require 'path'

module.exports =
    config:
        projectConfigs:
            title: 'Use project config'
            description: '.csscomb.json for example. Relative to the project directory. The details below.'
            default: ''
            type: 'string'
        readyMadeConfigs:
            title: 'Ready made configs'
            description: 'Used when you do not specify a project file. The details below.'
            type: 'string'
            default: 'yandex'
            enum: ['yandex', 'csscomb', 'zen']

    getSettingsConfig: ->
        projectConfigs = atom.config.get 'atom-css-comb.projectConfigs'
        readyMadeConfigs = atom.config.get 'atom-css-comb.readyMadeConfigs'
        cssCombPackage = atom.packages.getLoadedPackage 'atom-css-comb'
        projectPath = atom.project.getPaths()[0]

        if projectConfigs
            optionsFilePath = path.join(projectPath, projectConfigs)
            try
                require optionsFilePath
            catch error
                error
        else
            readyMadeConfigs || 'yandex'

    activate: (state) ->
        atom.commands.add 'atom-workspace', 'css-comb:comb': => @comb()

    comb: ->
        filePath = atom.workspace.getActivePaneItem().getPath()
        config = @getSettingsConfig()
        if config instanceof Error
            atom.notifications.addError(config.message)
        else
            comb = new Comb config
            comb
                .processPath(filePath)
                .then(->
                    atom.notifications.addSuccess('Css combed!')
                )
