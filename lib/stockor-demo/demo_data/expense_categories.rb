module StockorDemo
    module DemoData

        class ExpenseCategories < ModelCollection

            set_model Skr::ExpenseCategory

            def initialize( count )
                super()
                @gl_account = Skr::GlAccount.find_by_number('6300')
                ensure_record_count(count) do
                    begin
                        name = FN.name
                        code = Lanes::Strings.code_identifier(name)
                    end while model.where(code: code).any?
                    create(code, name)
                end
            end

            def create(code, name)
                super({
                    code: code, name: name, gl_account: @gl_account
                })
            end

        end

    end
end
