Comb = require 'csscomb'
CssCombView = require './css-comb-view'

module.exports =
    cssCombView: null

    config: ->
        configSet = atom.config.get 'css-comb.config'
        cssCombPackage = atom.packages.getLoadedPackage 'atom-css-comb'

        if configSet != 'custom'
            configSet
        else if configSet == 'custom'
            require cssCombPackage.path + '/configs/.csscomb.json'
        else
            'yandex'

    activate: (state) ->
        atom.workspaceView.command "css-comb:comb", => @comb()
        @cssCombView = new CssCombView(state.cssCombViewState)

    deactivate: ->
        @cssCombView.destroy()

    comb: ->
        filePath = atom.workspace.activePaneItem.getPath()
        comb = new Comb @config()
        comb.processPath(filePath)

    serialize: ->
        cssCombViewState: @cssCombView.serialize()
