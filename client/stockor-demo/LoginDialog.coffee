class StockorDemo.LoginDialog extends Lanes.Components.ModalDialog

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

    session:
        failure: 'boolean'
        message: 'string'

    bindings:
        failure: { type:'toggle', selector: '.alert' }
        message: { type: 'text',  selector: '.alert' }

    initialize: (options)->
        this.listenToAndRun(Lanes.current_user, 'change:isLoggedIn', this.onUserChange)


    onUserChange: ->
        this.toggleShown(!Lanes.current_user.isLoggedIn)

    onLogin: (ev)->
        user = new StockorDemo.UserModel(
            email: @ui.email.val(), name: @ui.name.val()
            role_names: [ this.query('input:checked').value ]
        )
        Lanes.Views.SaveNotify(this, model: user ).then (save)=>
            @failure = !save.success
            @message = user.lastServerMessage
            Lanes.current_user.setLoginData(save.data.user, save.data.access)
            @hide() if save.success


    onShown: ->
        @ui.name.focus()
