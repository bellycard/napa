require 'napa/deprecations/active_support_behavior'
require 'napa/deprecations/application_api'
require 'napa/deprecations/napa_setup'
require 'napa/deprecations/grape_entity'

module Napa
  class Deprecations
    def self.initialization_checks
      napa_setup_check
      application_api_check
    end
  end
end
