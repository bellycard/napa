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

run HelloService::API # <-- boot your service here --
  
