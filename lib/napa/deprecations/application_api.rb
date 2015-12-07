module Napa
  class Deprecations
    URL = 'https://github.com/bellycard/napa/blob/master/lib/napa/cli/templates/new/app/apis/application_api.rb'
    WARNING = "no application_api.rb file found in app/apis, see #{URL} for an example"
    def self.application_api_check
      unless File.exists?('./app/apis/application_api.rb')
        ActiveSupport::Deprecation.warn WARNING, caller
      end
    end
  end
end
