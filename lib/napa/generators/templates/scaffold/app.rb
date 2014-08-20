# load bundler
require 'bundler/setup'
Bundler.setup(:default)
require 'napa/setup'
Bundler.require(:default, Napa.env.to_sym)
require 'napa'

# load environment
Napa.load_environment

# autoload initalizers
Dir['./config/initializers/**/*.rb'].map { |file| require file }

# load middleware configs
Dir['./config/middleware/**/*.rb'].map { |file| require file }

# autoload app
relative_load_paths = %w(app/apis app/representers app/models app/workers lib)
ActiveSupport::Dependencies.autoload_paths += relative_load_paths
