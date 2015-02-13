require_relative '../stockor-demo-access'
require 'lanes/access/extension'
require 'skr/extension'

module StockorDemoAccess

    class Extension < Lanes::Extensions::Definition

        identifier "stockor-demo-access"

        root_path Pathname.new(__FILE__).dirname.join("..","..").expand_path

    end

end
