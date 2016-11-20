module StockorDemo
    module DemoData

        class CustomerProjects < ModelCollection

            set_model Skr::CustomerProject

            def initialize( count )
                super()
                @customers = Skr::Customer.order(:code).limit(9).to_a
                @customers.push Skr::Customer.find_by_code("STOCKOR")
                ensure_record_count(count) do
                    begin
                        description = FC.catch_phrase
                        code = Lanes::Strings.code_identifier(description)
                    end while model.where(code: code).any?

                    create(code, description)
                end
            end

            def create( code, description )
                rate = (rand * 100) + 50
                rate -= rate % 5
                super({
                    code: code,
                    description: description,
                    po_num: Faker::Team.name,
                    customer: @customers.sample,
                    sku: Skr::Sku.order('RANDOM()').first,
                    options: {color: (rand*10).to_i},
                    rates: {hourly: rate}
                })
            end

        end

    end
end
