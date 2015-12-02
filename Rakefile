#!/usr/bin/env rake
$LOAD_PATH.unshift 'lib', __dir__

Dir.glob('./tasks/*.rake').each { |r| import r }
require 'bundler/gem_tasks'
require 'napa/active_record_extensions/stats.rb'
require 'napa/active_record_extensions/seeder.rb'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

task :spec

require 'rubocop/rake_task'
RuboCop::RakeTask.new

task default: [:rubocop, :spec]
