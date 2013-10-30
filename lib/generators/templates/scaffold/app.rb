# load bundler
Bundler.setup(:default)
require 'napa'
Bundler.require(:default, Napa.env.to_sym)
require 'will_paginate'
require 'will_paginate/active_record' 

# load environment
Dotenv.load(Napa.env.test? ? ".env.test" : ".env")

# autoload lib
Dir['./lib/**/**/*.rb'].map {|file| require file }

# autoload initalizers
Dir['./config/initializers/**/*.rb'].map {|file| require file }

# load middleware configs
Dir['./config/middleware/**/*.rb'].map {|file| require file }

# autoload app
Dir['./app/**/**/*.rb'].map {|file| require file }
