class StockorDemoAccess.LoginDialog extends Lanes.Components.ModalDialog

    bodyTemplateName: 'dialog-body'
    templatePrefix: 'stockor-demo'
    hideOnBackdropClick: false
    showHideButton: false
    hideOnEsc: false

    size: 'md'
    title: 'Choose Login Role …'
    FILE: FILE

    domEvents:
        'click .btn-primary': 'onLogin'
        'shown.bs.modal' : 'onShown'

    buttons:
        login: { label: 'Begin Demo', type: 'primary' }

    ui:
        name:  'input[name=name]'
        email: 'input[name=email]'

    initialize: (options)->
        this.listenToAndRun(Lanes.current_user, 'change:isLoggedIn', this.onUserChange)


    onUserChange: ->
        this.toggleShown(!Lanes.current_user.isLoggedIn)

    onLogin: (ev)->
        user = new StockorDemoAccess.UserModel(
            email: @ui.email.val(), name: @ui.name.val()
            role_names: [ this.query('input:checked').value ]
        )
        Lanes.Views.SaveNotify(this, model: user )
            .then (resp)=>
                session = resp.reply.data
                Lanes.current_user.setLoginData(session.user, session.access)
                @hide()

    onShown: ->
        @ui.name.focus()
