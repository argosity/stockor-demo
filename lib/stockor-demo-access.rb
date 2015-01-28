require "lanes"
require 'require_all'
require_relative "stockor-demo-access/version.rb"
require_relative "stockor-demo-access/extension.rb"
require_relative "stockor-demo-access/patch_user_info"
require_rel 'stockor-demo-access'

# The main namespace for Stockor-demo-access
module StockorDemoAccess
    def self.table_name_prefix
        "stockor-demo-access_"
    end
end
