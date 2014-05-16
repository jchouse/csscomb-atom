Comb = require 'csscomb'
{File} = require 'pathwatcher'

module.exports =
    userConfig: ->
        console.log File
        # configPath = atom.packages.getLoadedPackage('atom-css-comb').path + '/configs/user.coffee'
        # atom.workspace.open(configPath)

    config: ->
        configSet = atom.config.get 'css-comb.config'

        if configSet
            configSet
        else
            'yandex'

    activate: () ->
        atom.workspaceView.command "css-comb:comb", => @comb()
        atom.workspaceView.command "css-comb:userConfig", => @userConfig()

    comb: ->
          filePath = atom.workspace.activePaneItem.getPath()
          comb = new Comb @config()
          comb.processPath(filePath)
