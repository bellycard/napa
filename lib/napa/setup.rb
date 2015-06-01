# setup for napa
# require the files that are required before everything else in napa
# useful if you want to use any variables/methods defined here without loading the rest of napa immediately
require 'active_support'

module Napa
  class << self
    def load_environment
      Dotenv.load(Napa.env.test? ? '.env.test' : '.env')
    end

    def skip_initialization
      @_skip_initialization || false
    end

    def skip_initialization=(value)
      @_skip_initialization = value if [TrueClass, FalseClass].include?(value.class)
    end

    def env
      @_env ||= ActiveSupport::StringInquirer.new(lookup_env)
    end

    def env=(environment)
      @_env = ActiveSupport::StringInquirer.new(environment)
    end

    def cache
      @_cache ||= ActiveSupport::Cache.lookup_store(:memory_store)
    end

    def cache=(store_option)
      @_cache = ActiveSupport::Cache.lookup_store(store_option)
    end

    def lookup_env
      ENV['RACK_ENV'] || ENV['RAILS_ENV'] || 'development'
    end

    def heroku?
      !!ENV['DYNO']
    end
  end
end
