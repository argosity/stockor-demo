class StockorDemo.Tester extends Lanes.Models.Base


    props:
        name:   'string'
        email:  'string'
        access: 'object'
        user:   'object'
        role:   type: 'string', default: 'administrator'

    api_path: "stockor-demo/demo-user"

    save: ->
        super.then =>
            Lanes.current_user.setLoginData(@user, @access) if @user
