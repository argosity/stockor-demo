##= require 'lanes/components/modal'

class StockorDemo.Extension extends Lanes.Extensions.Base

    FILE: FILE

    identifier: "stockor-demo"

    rootComponent: (viewport) ->
        Lanes.Workspace.Layout

    configureRollbar: ->
        Rollbar?.configure(
            payload: {
                user: {id: Lanes.current_user.id}
            }
        )

    # All extenensions have been given their data and Lanes has completed startup
    onAvailable: ->
        Rollbar?.configure(enabled: Lanes.config.env.production)
        @configureRollbar() if Lanes.current_user.isLoggedIn
        Lanes.current_user.on('change:isLoggedIn', @configureRollbar)

    onInitialized: ->
        # Overwrite the function responsible for creating the login dialog
        # with a function that returns our own dialog
        Lanes.Access.LoginDialog.instance = ->
            StockorDemo.LoginDialog
