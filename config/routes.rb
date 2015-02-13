Lanes::API.routes.draw do

    # It's a demo - we don't worry about security
    # find or create a user with the email and role they wanted
    # and then log them in with it

    post "/demo-user.json" do
        if data['name'].blank? || data['email'].blank?
            return { success:false, message: "Need name and email for demo" }
        end

        user_id = case data['role_names'].first
                  when 'administrator'    then 1
                  when 'accounting'       then 2
                  when 'customer_support' then 3
                  when 'purchasing'       then 4
                  else
                      1
                  end

        session['user_id'] = user_id
        session['name']  = data[:name]
        session['email'] = data[:email]

        wrap_json_reply do
            { success: true, data: Lanes::User.find(user_id).workspace_data }
        end

    end


end
