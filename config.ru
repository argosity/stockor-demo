require 'bundler'
Bundler.require
require_relative 'lib/stockor-demo-access'
require 'lanes/api'
run Lanes::API::Root
