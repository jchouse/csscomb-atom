Comb = require 'csscomb'
CssCombView = require './css-comb-view'

module.exports =
    cssCombView: null

    config: ->
        configSet = atom.config.get 'css-comb.config'
        cssCombPackage = atom.packages.getLoadedPackage 'atom-css-comb'

        if configSet != 'custom'
            configSet || 'yandex'
        else if configSet == 'custom'
            require cssCombPackage.path + '/configs/.csscomb.json'

    activate: (state) ->
        atom.commands.add 'atom-workspace', 'css-comb:comb': => @comb()
        @cssCombView = new CssCombView(state.cssCombViewState)

    deactivate: ->
        @cssCombView.destroy()

    comb: ->
        filePath = atom.workspace.getActivePaneItem().getPath()
        comb = new Comb @config()
        comb.processPath(filePath)

    serialize: ->
        cssCombViewState: @cssCombView.serialize()
