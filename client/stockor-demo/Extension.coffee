class StockorDemo.Extension extends Lanes.Extensions.Base

    FILE: FILE

    identifier: "stockor-demo"

    onRegistered: ->
        Lanes.Access.createLoginDialog = (view)->
            new StockorDemo.LoginDialog( parent: view )
