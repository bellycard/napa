# setup for napa
# require the files that are required before everything else in napa
# useful if you want to use any variables/methods defined here without loading the rest of napa immediately
require 'active_support'

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
