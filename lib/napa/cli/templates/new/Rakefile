#!/usr/bin/env rake
require 'napa/setup'
require 'dotenv'
Napa.load_environment

require './app'
require 'json'

Dir.glob('./lib/tasks/*.rake').each { |r| import r }
