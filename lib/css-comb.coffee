Comb = require 'csscomb'

module.exports =
    userSettings: ->
        userConfig = atom.config.get 'css-comb.userConfig'
        cssCombPackage = atom.packages.getLoadedPackage 'atom-css-comb'

        if !userConfig
            atom.config.set 'css-comb.userConfig', true

        atom.workspace.open cssCombPackage.path + '/configs/.csscomb.json'

    config: ->
        configSet = atom.config.get 'css-comb.config'
        userConfig = atom.config.get 'css-comb.userConfig'
        cssCombPackage = atom.packages.getLoadedPackage 'atom-css-comb'

        if configSet
            configSet
        else if userConfig
            require cssCombPackage.path + '/configs/.csscomb.json'
        else
            'yandex'

    activate: () ->
        atom.workspaceView.command "css-comb:comb", => @comb()
        atom.workspaceView.command "css-comb:userSettings", => @userSettings()

    comb: ->
        filePath = atom.workspace.activePaneItem.getPath()
        comb = new Comb @config()
        comb.processPath(filePath)
