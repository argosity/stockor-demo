module StockorDemo::DemoData

    class Invoices < ModelCollection

        api_path 'invoices'
        set_model Skr::Invoice

        def initialize( count )
            super()
            @customers = Skr::Customer.order(:code).limit(9)
            ensure_record_count( count ) do
                self.create
            end

        end

        def record_options
            { :include=>['lines'] }
        end

        def create
            location = Skr::Location.order('RANDOM()').first

            lines = []
            skus = Skr::Sku.in_location(location.id)
                     .where(is_other_charge: false)
                     .order('RANDOM()')
                     .limit(rand(40))
            skus.each do | sku |
                l = { qty: rand(20)+1 }
                sl = sku.sku_locs.for_location(location)
                n = rand(5)
                if n <= 2
                    sol = Skr::SoLine.open.order('RANDOM()').first
                    l.merge!({ so_line: sol, sku_loc: sol.sku_loc })
                elsif 3 == n and Skr::TimeEntry.open.any?
                    te = Skr::TimeEntry.open.order('RANDOM()').first
                    l.merge!({time_entry: te,
                              sku_loc: te.customer_project
                                  .sku.sku_locs.for_location(location)} || sl)
                else
                    l.merge!({time_entry: te, sku_loc: sl})
                end
                lines.push( l )
            end

            super({
                    customer: @customers.sample,
                    po_num: Faker::Number.number(10),
                    location: location,
                    lines_attributes: lines
                })

        end

    end
end
