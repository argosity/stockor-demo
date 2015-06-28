##= require 'lanes/components/modal'

class StockorDemo.Extension extends Lanes.Extensions.Base

    FILE: FILE

    identifier: "stockor-demo"

    rootComponent: (viewport) ->
        Lanes.Workspace.Layout

    onInitialized: ->
        # Overwrite the function responsible for creating the login dialog
        # with a function that returns our own dialog
        Lanes.Access.LoginDialog.instance = ->
            @cache ||= React.createFactory(StockorDemo.LoginDialog)
