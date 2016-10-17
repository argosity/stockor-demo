module StockorDemo
    module DemoData

        class Users < ModelCollection

            set_model Lanes::User

            def initialize( count )
                super()
                ensure_record_count(count) do
                    create
                end
            end

            def create
                pw = FI.password
                attrs = {
                    login: FI.user_name, name: FN.name, email: FI.email,
                    password: pw, password_digest: pw
                }
                super(attrs)
            end

        end

    end
end
