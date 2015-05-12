Comb = require 'csscomb'
CssCombView = require './css-comb-view'
path = require 'path'

module.exports =
    cssCombView: null

    config: ->
        configSet = atom.config.get 'css-comb.config'
        cssCombPackage = atom.packages.getLoadedPackage 'atom-css-comb'
        projectPath = atom.project.getPaths()[0]

        if configSet == 'project'
            optionsFilePath = path.join(projectPath, '.csscomb.json')
        else if configSet == 'common'
            optionsFilePath = path.join(cssCombPackage.path, 'configs', '.csscomb.json')

        if optionsFilePath
            try
                require optionsFilePath
            catch error
                error
        else
            configSet || 'yandex'

    activate: (state) ->
        atom.commands.add 'atom-workspace', 'css-comb:comb': => @comb()
        @cssCombView = new CssCombView(state.cssCombViewState)

    deactivate: ->
        @cssCombView.destroy()

    comb: ->
        filePath = atom.workspace.getActivePaneItem().getPath()
        config = @config()
        if config instanceof Error
            atom.notifications.addError(config.message)
        else
            comb = new Comb @config()
            comb
                .processPath(filePath)
                .then(->
                    atom.notifications.addSuccess('Css combed!')
                )

    serialize: ->
        cssCombViewState: @cssCombView.serialize()
