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
                record_active_record_errors(tester)
            end
        end
    end

end

class Lanes::API::Root

    get Lanes.config.api_path + '/boostrap.json' do
        content_type 'application/json'
        client_bootstrap_data
    end
    before do
        # seems to work well enough for google...
        headers 'P3P' => 'CP="This is not a P3P policy! See http://www.google.com/support/accounts/bin/answer.py?hl=en&answer=151657 for more info."'
    end
end

Lanes::API::Root::CORS_PATHS['*'] = {
    origins: '*',
    methods: [:get, :post, :put, :delete, :options]
}
