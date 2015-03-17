require "lanes"
require 'require_all'
require 'lanes/access'
require_relative "stockor-demo/version.rb"
require_relative "stockor-demo/extension.rb"
require_relative "stockor-demo/patch_user_info"

module StockorDemo

    ROLE_IDS = {
                administrator: 1,
                accounting: 2,
                support:3,
                purchasing: 4
    }

    extend self


end

require_relative "stockor-demo/model"
require_rel "stockor-demo/models"
