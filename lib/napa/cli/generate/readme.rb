require 'thor'
require 'active_support/all'
require 'napa/setup'
require 'napa/identity'
require 'dotenv'

module Napa
  module CLI
    class Generate < Thor

      include Thor::Actions

      desc "readme", "Create a formatted README"
      def readme
        self.class.source_root File.expand_path("../../templates/readme", __FILE__)
        say 'Generating README...'
        directory '.', output_directory
        say 'Done!', :green
      end

      no_commands do

        def service_name
          Napa::Identity.name
        end

        def output_directory
          '.'
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

      end

    end
  end
end
