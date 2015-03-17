module StockorDemo

    class Tester < ::StockorDemo::Model

        validates :name, presence: true
        validates :email, email: true, uniqueness: { case_sensitive: false }

        attr_accessor :role
        def self.record(data, session)
            parts = data.slice('name','email')
            session.merge!(parts.stringify_keys)
            tester = Tester.find_or_initialize_by(email: parts['email'])
            tester.name = data['name']
            tester.visits << Date.today.strftime("%F")
            tester.role = data['role_names'].first
            tester.save
            tester
        end

        def user
            @user ||= Lanes::User.find(user_id)
        end

        def user_id
            case self.role
            when 'administrator'    then 1
            when 'accounting'       then 2
            when 'customer_support' then 3
            when 'purchasing'       then 4
            else
                1
            end
        end
    end

end
