require_relative '../../lib/stockor-demo'
require 'lanes/spec_helper'

module StockorDemo

    # Add more helper methods to be used by all tests here...

    class TestCase < Lanes::TestCase
        include StockorDemo
    end

    class ApiTestCase < Lanes::ApiTestCase
        include StockorDemo
    end

end
