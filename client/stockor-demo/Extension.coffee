class StockorDemo.Extension extends Lanes.Extensions.Base

    FILE: FILE

    identifier: "stockor-demo-access"

    onRegistered: ->
        Lanes.Access.createLoginDialog = (view)->
            new StockorDemo.LoginDialog( parent: view )
