require 'lanes/api'

module Lanes

    API::Root.before do
        Thread.current[:demo_user_info] = {
          name: session[:name],
          email: session[:email]
        }
    end

    module Workspace

        module Updates

            def self.user_info_for_change(model)
                Thread.current[:demo_user_info]
            end

        end

    end
end
