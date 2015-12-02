module Napa
  class Deprecations
    LINK = 'https://github.com/bellycard/napa/blob/master/lib/napa/generators/templates/scaffold/app/apis/application_api.rb'
    WARNING = "no application_api.rb file found in app/apis, see #{LINK} for an example"
    def self.application_api_check
      unless File.exists?('./app/apis/application_api.rb')
        ActiveSupport::Deprecation.warn WARNING, caller
      end
    end
  end
end
