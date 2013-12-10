# require external libraries
require 'rake'
require 'dotenv'
require 'logging'
require 'octokit'
require 'grape'
require 'json'

# require internal files
require 'napa/version'
require 'napa/logger/logger'
require 'napa/logger/log_transaction'
require 'napa/identity'
require 'napa/json_error'
require 'napa/grape_extensions/error_formatter'
require 'napa/grape_extensions/error_presenter'
require 'napa/middleware/logger'
require 'napa/middleware/app_monitor'
require 'napa/activerecord'
require 'napa/grape_api'
require 'generators/scaffold'

# load rake tasks if Rake installed
if defined?(Rake)
  load 'tasks/git.rake'
  load 'tasks/deploy.rake'
  load 'tasks/routes.rake'
  load 'tasks/db.rake'
end

module Napa
  class << self
    def env
      @_env ||= ActiveSupport::StringInquirer.new(ENV['RACK_ENV'] || 'development')
    end

    def env=(environment)
      @_env = ActiveSupport::StringInquirer.new(environment)
    end
  end
end
