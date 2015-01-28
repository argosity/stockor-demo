require_relative '../../lib/StockorDemoAccess'
require 'lanes/spec_helper'

module StockorDemoAccess

    # Add more helper methods to be used by all tests here...

    class TestCase < Lanes::TestCase
        include StockorDemoAccess
    end

    class ApiTestCase < Lanes::ApiTestCase
        include StockorDemoAccess
    end

end
