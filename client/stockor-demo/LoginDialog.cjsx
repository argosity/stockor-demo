class StockorDemo.LoginDialog extends Lanes.React.Component

    statics:
        show: (viewport, props = {}) ->

            tester = new StockorDemo.Tester(name: "Joe Cool", email: "Joe@Test.com")
            handler = new _.Promise( (onOk, onCancel) ->
                viewport.modalProps = _.extend({}, props,
                    title: 'View Stockor Demo'
                    onCancel: onCancel, onOk: onOk, show: true,
                    buttons: [{ title: 'Ok', style: 'primary'}]
                    body: ->
                        <StockorDemo.LoginDialog model={tester} attemptLogin={onOk} />
                )
            )
            handler.then (dlg) ->
                tester.save(ignoreErrors: true).then ->
                    _.extend(viewport.modalProps, {show: _.any(tester.errors)})

    mixins: [
        Lanes.React.Mixins.RelayEditingState
    ]

    dataObjects: ->
        model: 'props'

    getDefaultProps: ->
        writable: true, editOnly: true

    login: ->
        @model.save()

    warning: ->
        <BS.Alert bsStyle='warning'>
             <strong>{@model.lastServerMessage}</strong>
        </BS.Alert>

    setRole: (ev) ->
        @setState(role: ev.currentTarget.value)

    setRoleFromRow: (ev) ->
        input = ev.target.parentElement.querySelector('input')
        @model.role = input.value

    onHide: Lanes.emptyFn

    render: ->
        <div className='modal-body tester-login'>
            <p className="lead">
              We will only send you a single follow-up email.
            </p>
            {@warning() if @state.hasError}
            <BS.Row>
                <BS.Col sm={12} md={6}>
                    <LC.Input
                        model={@model}
                        autoFocus
                        name="name"
                        label='Name'
                        placeholder='Your Name'
                    />
                </BS.Col>
                <BS.Col sm={12} md={6}>
                    <LC.Input
                        model={@model}
                        name="email"
                        type='email'
                        label='Email'
                        placeholder='Enter Email Address'
                    />
                </BS.Col>
            </BS.Row>

            <h4>
              Role to test with:
            </h4>
            <table className="table table-striped table-hover" onClick={@setRoleFromRow}>
                <tbody>
                    <tr>
                      <td align="center">
                        <LC.RadioField writable name="role" value="administrator" model={@model} />
                      </td>
                      <td>Administrator</td>
                      <td>Control ALL THE THINGS</td>
                    </tr><tr>
                      <td align="center">
                        <LC.RadioField name="role" value="accounting" model={@model} />
                      </td>
                      <td>Accounting</td>
                      <td>Financial information, sets credit limits.</td>
                    </tr><tr>
                      <td align="center">
                        <LC.RadioField name="role" value="customer_support"
                          model={@model} />
                      </td>
                      <td>Customer Service</td>
                      <td>Customer and Sales Orders</td>
                    </tr><tr>
                      <td align="center">
                        <LC.RadioField name="role" value="purchasing" model={@model} />
                      </td>
                      <td>Purchasing</td>
                      <td>Vendors and Purchase Orders</td>
                    </tr>
                </tbody>
            </table>

        </div>
