#!/usr/bin/env rake
require 'dotenv'
Dotenv.load(ENV['RACK_ENV'] == 'test' ? '.env.test' : '.env')

require './app'
require 'json'

Dir.glob('./lib/tasks/*.rake').each { |r| import r }
