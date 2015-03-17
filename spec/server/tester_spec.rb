require_relative 'spec_helpers'

class TesterSpec < StockorDemo::TestCase

    it "can records data" do
        session={}
        params = {'name'=>'Tester', 'email'=>'test@test.com', 'role_names'=>['admin']}
        assert_difference(->{Tester.count},1) {
            model = Tester.record(params, session)
            %w{name email}.each do | attr |
                assert_equal params[attr], model[attr]
                assert_equal params[attr], session[attr]
            end
        }
    end

end
