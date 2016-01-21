module StockorDemo
    module DemoData

        class Vendors < ModelCollection

            set_model Skr::Vendor

            def initialize( count )
                super()

                @gl_payables = Skr::GlAccount.default_for(:ap)
                @gl_friehgt  = Skr::GlAccount.where(number: '6420').first!

                ensure_record_count(count) do
                    begin
                        name = FC.name
                        code = Lanes::Strings.code_identifier(name)
                    end while model.where(code: code ).any?
                    create(code, name)
                end
                unless Skr::Vendor.find_by_code("STOCKOR")
                    create("STOCKOR", "Stockor test customer")
                end

            end

            def create( code, name )
                super({
                          :code                   => code,
                          :name                   => name,
                          :billing_address        => DemoData.make_address(name),
                          :shipping_address       => DemoData.make_address(name),
                          :terms                  => DemoData.terms.random,
                          :notes                  => FC.catch_phrase,
                          :gl_payables_account    => @gl_payables,
                          :gl_freight_account     => @gl_freight
                      })
            end

        end

    end
end
