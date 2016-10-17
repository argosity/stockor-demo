module StockorDemo
    module DemoData

        class ExpenseEntries < ModelCollection

            set_model Skr::ExpenseEntry

            def initialize( count )
                super()
                ensure_record_count(count) do
                    Lanes::User.scoped_to(DemoData.users.random.id) do
                        create
                    end
                end
            end

            def create
                entry = model.new(
                    name: FS.product_name,
                    occured: Faker::Date.backward(28) + (rand(8).to_i+8).hours
                )

                (rand(4)+1).times do
                    entry.categories.build(
                        { amount: FS.price, category: DemoData.expense_cats.random }
                    )
                end
                entry.save!
            end

        end

    end
end
