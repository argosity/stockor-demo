module StockorDemo
    module DemoData

        class TimeEntries < ModelCollection

            set_model Skr::TimeEntry

            def initialize( count )
                super()
                ensure_record_count(count) do
                    create
                end
            end

            def create
                start = Faker::Date.backward(28) + (rand(8).to_i+8).hours
                super({
                          customer_project: Skr::CustomerProject.order('RANDOM()').first,
                          lanes_user: Lanes::User.order('RANDOM()').first,
                          is_invoiced: (0 == rand(3).to_i),
                          start_at: start,
                          end_at: start + (rand(8).to_i+2).hours,
                          description: FC.bs
                      })
            end

        end

    end
end
