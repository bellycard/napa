#!/usr/bin/env rake
$LOAD_PATH.unshift 'lib', __dir__

Dir.glob('./tasks/*.rake').each { |r| import r }
require 'bundler/gem_tasks'
require 'napa/active_record_extensions/stats.rb'
require 'napa/active_record_extensions/seeder.rb'

task default: :spec
