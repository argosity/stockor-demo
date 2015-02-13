require 'bundler'
Bundler.require
require_relative 'lib/stockor-demo'
require 'lanes/api'
run Lanes::API::Root
