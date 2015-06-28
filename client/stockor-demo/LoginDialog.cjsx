class StockorDemo.LoginDialog extends Lanes.React.Component

    mixins: [
        Lanes.React.Mixins.RelayEditingState
    ]

    dataObjects: ->
        model: new StockorDemo.Tester(name: "Joe Cool", email: "Joe@Test.com")

    # getInitialState: ->
    #     editing: true

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
        <LC.Modal title='Stockor Demo'
            backdrop={true}
            onRequestHide={@onHide}
            closeButton={false}
            animation={false}>

            <div className='modal-body tester-login'>
                <p className="lead">
                  We will only send you a single follow-up email, that it.
                </p>
                {@warning() if @state.hasError}
                <BS.Row>
                    <BS.Col sm={12} md={6}>
                        <LC.TextField
                            model={@model}
                            autoFocus
                            name="name"
                            label='Name'
                            placeholder='Your Name'
                        />
                    </BS.Col>
                    <BS.Col sm={12} md={6}>
                        <LC.TextField
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

                </table>

            </div>
            <div className='modal-footer'>
              <BS.Button onClick={@login} bsStyle='primary'>Login</BS.Button>
            </div>

        </LC.Modal>
