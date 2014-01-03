require 'thor'
require 'active_support/core_ext/string'

module Napa
  module Generators
    class ApiGenerator < Thor::Group
      include Thor::Actions

      source_root "#{File.dirname(__FILE__)}/templates/api"

      argument :api_name

      def generate
        say 'Generating api...'

        directory 'api', '.'

        say 'Done!', :green
      end
    end
  end
end
