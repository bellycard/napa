require 'thor'
require 'active_support/all'

module Napa
  module Generators
    class ApiGenerator < Thor::Group
      include Thor::Actions

      source_root "#{File.dirname(__FILE__)}/templates/api"

      argument :api_name

      def api_name_underscore
        api_name.underscore
      end

      def api_name_tableize
        api_name.tableize
      end

      def generate
        say 'Generating api...'

        directory '.', '.'

        say 'Done!', :green
      end
    end
  end
end
