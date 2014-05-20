Comb = require 'csscomb'
{File} = require 'pathwatcher'
# file = new File()

module.exports =
    userConfig: ->
        path = atom.project.path + '/config.csscomb.js'
        file = new File(path)
        file.read().then () => @putNewConfigs(file, path)

    putNewConfigs: (file, path) ->
        file.write('test')
        atom.workspace.open(path)

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
