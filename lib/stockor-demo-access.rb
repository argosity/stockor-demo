require "lanes"
require 'require_all'
require 'lanes/access'
require_relative "stockor-demo-access/version.rb"
require_relative "stockor-demo-access/extension.rb"
require_relative "stockor-demo-access/patch_user_info"

module StockorDemoAccess

    ROLE_IDS = {
                administrator: 1,
                accounting: 2,
                support:3,
                purchasing: 4
    }

    extend self

    def user_for(role)
        f
    end
end
