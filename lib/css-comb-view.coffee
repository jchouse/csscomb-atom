{View, EditorView, $} = require 'atom'

module.exports =
class CssCombView extends View
    @content: ->
        @div class: 'css-comb overlay from-top', =>
            @h2 'CSS Comb settings:'
            @h3 'Ready-made preferences'
            @div class: 'css-comb__block', =>
                @div class: 'css-comb__row', =>
                    @tag 'label', 'yandex', =>
                        @tag 'input',
                            type: 'radio'
                            name: 'csscomb'
                            value: 'yandex'
                @div class: 'css-comb__row', =>
                    @tag 'label', 'csscomb', =>
                        @tag 'input',
                            type: 'radio'
                            name: 'csscomb'
                            value: 'csscomb'
                @div class: 'css-comb__row', =>
                    @tag 'label', 'zen', =>
                        @tag 'input',
                            type: 'radio'
                            name: 'csscomb'
                            value: 'zen'
                @div class: 'css-comb__row', =>
                    @tag 'label', 'alphabetize', =>
                        @tag 'input',
                            type: 'radio'
                            name: 'csscomb'
                            value: 'alphabetize'
            @h3 'Own preferences'
            @div class: 'css-comb__block', =>
                @div class: 'css-comb__row', =>
                    @tag 'label', 'custom config', =>
                        @tag 'input',
                            type: 'radio'
                            name: 'csscomb'
                            value: 'custom'
                    @button class: "btn btn-sg css-comb-config disabled", 'Edit config file'
            @div class: 'css-comb__row css-comb__row_aright', =>
                @button class: "btn btn-lg css-comb-close", 'Close'

    initialize: (serializeState) ->
        atom.workspaceView.command "css-comb:userSettings", => @toggle()

    # Returns an object that can be retrieved when package is activated
    serialize: ->

    # Tear down any state and detach
    destroy: ->
        @detach()

    toggle: ->
        if @hasParent()
            @detach()
        else
            atom.workspaceView.append(this)
            @setActions()

    setActions: ->
        config = atom.config.get 'css-comb.config'
        radioButtonValue =  config ? 'yandex'
        cssCombPackage = atom.packages.getLoadedPackage 'atom-css-comb'

        $(':radio', @).change (e) =>
            value = $(e.target).val() != config
            atom.config.set 'css-comb.config', $(e.target).val() if value
            if $('input[value=custom]:radio', @).prop 'checked'
                $('.css-comb-config', @).removeClass 'disabled'
            else
                $('.css-comb-config', @).addClass 'disabled'

        $('input[value=' + radioButtonValue + ']:radio', @).prop 'checked', (i, val) ->
            $(@).trigger 'change'
            true

        $('.css-comb-close', @).click () =>
            @detach()

        $('.css-comb-config', @).click () =>
            @userSettings()

    userSettings: ->
        cssCombPackage = atom.packages.getLoadedPackage 'atom-css-comb'

        atom.workspace.open cssCombPackage.path + '/configs/.csscomb.json'
