class StockorDemo.LoginDialog extends Lanes.React.Component

    statics:
        show: (viewport, props = {}) ->
            tester = new StockorDemo.Tester
            saveTester = (dlg) ->
                tester.save().then ->
                    dlg.hide() if _.isEmpty tester.errors

            viewport.modalProps = _.extend({}, props,
                title: 'View Stockor Demo'
                onCancel: null, onOk: saveTester, show: true,
                buttons: [{ title: 'Login', style: 'primary', eventKey: 'ok'}]
                body: (props) ->
                    <StockorDemo.LoginDialog
                        {...props} model={tester} attemptLogin={saveTester} />
                )

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
        roleProps = {name: "role", model: @model, fieldOnly: true}
        <div className='modal-body tester-login'>
            <LC.ErrorDisplay model={@props.model} />
            <p className="lead">
              We will only send you a single follow-up email.
            </p>
            <BS.Row>
                <LC.Input
                    sm={12} md={6}
                    model={@model}
                    onEnter={=> @props.attemptLogin(@props.modal)}
                    autoFocus
                    name="name"
                    label='Name'
                    placeholder='Your Name'
                />

                <LC.Input
                    sm={12} md={6}
                    model={@model}
                    onEnter={=> @props.attemptLogin(@props.modal)}
                    name="email"
                    type='email'
                    label='Email'
                    placeholder='Enter Email Address'
                />
            </BS.Row>

            <h4>
              Role to test with:
            </h4>
            <table className="table table-striped table-hover" onClick={@setRoleFromRow}>
                <tbody>
                    <tr>
                      <td align="center">
                        <LC.RadioField writable  {...roleProps} value="administrator" />
                      </td>
                      <td>Administrator</td>
                      <td>Con
                      trol ALL THE THINGS</td>
                    </tr><tr>
                      <td align="center">
                        <LC.RadioField {...roleProps} value="accounting" />
                      </td>
                      <td>Accounting</td>
                      <td>Financial information, sets credit limits.</td>
                    </tr><tr>
                      <td align="center">
                        <LC.RadioField {...roleProps} value="customer_support" />
                      </td>
                      <td>Customer Service</td>
                      <td>Customer and Sales Orders</td>
                    </tr><tr>
                      <td align="center">
                        <LC.RadioField {...roleProps} value="purchasing" />
                      </td>
                      <td>Purchasing</td>
                      <td>Vendors and Purchase Orders</td>
                    </tr>
                </tbody>
            </table>

        </div>
