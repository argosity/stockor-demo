module StockorDemo::DemoData

    class SalesOrders < ModelCollection

        api_path 'sales_orders'
        set_model Skr::SalesOrder

        def initialize( count )
            super()
            @customers = Skr::Customer.order(:code).limit(9)
            ensure_record_count( count ) do
                self.create
            end

            # fetch( self.api_path_name,
            #        :scope=>{:pickable=>true},:include=>["lines"]).each do | so |
            #     pick(so) unless ( 0 == rand(5) )
            # end
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
                sl = sku.sku_locs.for_location(location)
                lines.push( { sku_loc_id: sl.id, qty: rand(20)+1 } )
            end

            super({
                    customer: @customers.sample,
                    po_num: Faker::Number.number(10),
                    ship_partial: ( 0 == rand(1) ),
                    location: location,
                    lines_attributes: lines
                })

        end

        # def pick( so )
        #     pt = parse( DemoData.skr.get( 'pick_tickets/from_orders' )
        #             .arguments( :order_ids=>[so.id] )
        #             .include('lines')
        #             .results
        #         ).first
        #     unless ( 0 == rand(5) )
        #         invoice( pt )
        #     end
        # end

        # def invoice( pt )
        #     parse( DemoData.skr.create( 'invoices', {
        #                 pick_ticket_id: pt.id,
        #                 amount_paid: ( 0 == rand(2) ) ? pt.lines.inject(0){|sum,ptl| sum+(ptl.price.to_f * ptl.qty.to_i) } : 0.0,
        #                 lines_attributes: pt.lines.map{ | ptl |
        #                     { pt_line_id: ptl.id, qty: ptl.qty }
        #                 }
        #             }, { :include=>['lines'] } ) )
        # end
    end
end
