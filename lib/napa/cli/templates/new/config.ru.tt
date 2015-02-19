require './app'

# Experimental StatsD Emitter for ActiveRecord
# require 'napa/active_record_extensions/stats.rb'

# use Rack::Cors do
#   allow do
#     origins '*'
#     resource '*', headers: :any, methods: [:get, :post, :delete, :put, :options]
#   end
# end
#
# use Honeybadger::Rack::ErrorNotifier
# use Napa::Middleware::Logger

use Napa::Middleware::AppMonitor
# Uncomment to require header passwords for all requests
# use Napa::Middleware::Authentication
use ActiveRecord::ConnectionAdapters::ConnectionManagement

run ApplicationApi
