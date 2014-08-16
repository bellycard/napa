module Napa
  class Deprecations
    def self.application_api_check
      unless File.exists?('./app/apis/application_api.rb')
        ActiveSupport::Deprecation.warn 'no application_api.rb file found in app/apis, see https://github.com/bellycard/napa/blob/master/lib/napa/generators/templates/scaffold/app/apis/application_api.rb for an example', caller
      end
    end
  end
end
