require 'stockor-demo'

Lanes::API.routes.for_extension 'stockor-demo' do

    # It's a demo - we don't worry about security
    # find or create a user with the email and role they wanted
    # and then log them in with it

    post 'demo-user.json' do
        wrap_reply do
            tester = StockorDemo::Tester.record(data, session)
            if tester.valid?
                session['user_id'] = tester.user.id
                { success: true, data: tester.user.workspace_data }
            else
                { success:false, message: tester.errors.full_messages.join(", ") }
            end
        end

    end

    root_view :lanes_root_view

end
