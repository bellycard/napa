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
require 'napa/identity'
require 'napa/json_error'
require 'napa/stats'
require 'napa/active_record_extensions/filter_by_hash'
require 'napa/grape_extensions/error_formatter'
require 'napa/grape_extensions/grape_helpers'
require 'napa/grape_extensions/entity'
require 'napa/grape_extensions/include_nil'
require 'napa/grape_extensions/representer'
require 'napa/grape_extenders'
require 'napa/middleware/logger'
require 'napa/middleware/app_monitor'
require 'napa/middleware/authentication'
require 'napa/middleware/request_stats'
require 'napa/authentication'

# load rake tasks if Rake installed
if defined?(Rake)
  load 'tasks/git.rake'
  load 'tasks/deploy.rake'
  load 'tasks/routes.rake'
  load 'tasks/db.rake'
end
