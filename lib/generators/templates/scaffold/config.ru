require './app'

# use Rack::Cors do
#   allow do
#     origins '*'
#     resource '*', headers: :any, methods: :any
#   end
# end
#
# use Honeybadger::Rack
# use Napa::Middleware::Logger

use Napa::Middleware::AppMonitor
use Napa::Middleware::Authentication
use ActiveRecord::ConnectionAdapters::ConnectionManagement

run HelloService::API # <-- boot your service here --

