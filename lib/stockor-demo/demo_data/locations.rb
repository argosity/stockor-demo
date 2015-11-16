module StockorDemo
    module DemoData

        class Locations < ModelCollection

            set_model Skr::Location

            def initialize( count )
                super()
                ensure_record_count( count ) do
                    begin
                        code = Faker::Address.city_prefix.upcase
                    end while model.where(code: code ).any?
                    self.create( code )
                end
                # self.each do | location |
                #     File.open( File.join(File.dirname(__FILE__), "demo-logo.png") ) do | io |
                #         DemoData.skr.upload( "locations/#{location.id}/images", :image=> io )
                #     end
                # end
            end

            def create( code )
                name = Faker::Address.street_name
                super({
                          code: code,
                          name: name,
                          address: DemoData.make_address( name )
                      })
            end
        end
    end
end
