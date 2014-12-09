# require external libraries
require 'rake'
require 'dotenv'
require 'logging'
require 'octokit'
require 'grape'
require 'grape-entity'
require 'json'

# require internal files
require 'napa/setup'
require 'napa/version'
require 'napa/logger/logger'
require 'napa/logger/log_transaction'
require 'napa/logger/parseable'
require 'napa/identity'
require 'napa/json_error'
require 'napa/stats'
require 'napa/stats_d_timer'
require 'napa/active_record_extensions/filter_by_hash'
require 'napa/active_record_extensions/stats'
require 'napa/active_record_extensions/seeder'
require 'napa/grape_extensions/error_formatter'
require 'napa/grape_extensions/grape_helpers'
require 'napa/output_formatters/entity'
require 'napa/output_formatters/include_nil'
require 'napa/output_formatters/representer'
require 'napa/grape_extenders'
require 'napa/middleware/logger'
require 'napa/middleware/app_monitor'
require 'napa/middleware/authentication'
require 'napa/middleware/request_stats'
require 'napa/middleware/database_stats'
require 'napa/authentication'
require 'napa/sortable_api'

require 'napa/deprecations'
require 'napa/deploy'
require 'napa/gem_dependency'

# load rake tasks if Rake installed
if defined?(Rake)
  load 'tasks/deploy.rake'
  load 'tasks/routes.rake'
  load 'tasks/db.rake'
end

module Napa
  class << self
    def initialize
      unless Napa.skip_initialization
        Napa::Logger.logger.info Napa::GemDependency.log_all if Napa.env.production?
        Napa::Deprecations.initialization_checks
      end
    end
  end
end

Napa.initialize
