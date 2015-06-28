class StockorDemo.Tester extends Lanes.Models.Base

    api_path: "demo-user"
    props:
        name:   'string'
        email:  'string'
        access: 'object'
        user:   'object'
        role:   type: 'string', default: 'administrator'


    save: ->
        super.then =>
            Lanes.current_user.setLoginData(@user, @access) if @user
