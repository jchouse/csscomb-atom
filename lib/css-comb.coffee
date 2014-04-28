{View} = require 'atom'
Comb = require 'csscomb'

module.exports =
    config: ->
        configSet = atom.config.get 'css-comb.config'

        if configSet
            configSet
        else
            'yandex'

    activate: () ->
        atom.workspaceView.command "css-comb:comb", => @comb()

    comb: ->
          filePath = atom.workspace.activePaneItem.getPath()
          comb = new Comb @config()
          comb.processPath(filePath)
