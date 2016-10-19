require_relative '../stockor-demo'
require 'lanes/access/extension'
require 'skr/extension'

module StockorDemo

    class Extension < Lanes::Extensions::Definition

        identifier "stockor-demo"

        root_path Pathname.new(__FILE__).dirname.join("..","..").expand_path

        def each_static_asset
            super do | entry |
                yield entry
            end
            [ 'stockor-demo/remote.js', 'stockor-demo/remote.css' ].each { | asset |
                yield asset
            }
        end

    end

end
