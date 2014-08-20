require 'thor'
require 'active_support/all'
require 'napa/setup'
require 'napa/identity'
require 'dotenv'

module Napa
  module Generators
    class ReadmeGenerator < Thor::Group
      include Thor::Actions

      def service_name
        Napa::Identity.name
      end

      def routes
        routes = ""

        if defined? ApplicationApi
          ApplicationApi.routes.each do |api|
            method      = api.route_method.ljust(10)
            path        = api.route_path.ljust(40)
            description = api.route_description
            routes     += "     #{method} #{path} # #{description}"
          end
        end

        routes
      end

      def output_directory
        '.'
      end

      def readme
        self.class.source_root "#{File.dirname(__FILE__)}/templates/readme"
        say 'Generating readme...'
        directory '.', output_directory
        say 'Done!', :green
      end
    end
  end
end
