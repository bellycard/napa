require 'thor'
require 'active_support/all'

module Napa
  module Generators
    class ApiGenerator < Thor::Group
      include Thor::Actions
      argument :generator_name # allows us to type reasonable CLI commands
      argument :name

      def name_underscore
        name.underscore
      end

      def name_tableize
        name.tableize
      end

      def generate
        self.class.source_root "#{File.dirname(__FILE__)}/templates/api"
        say 'Generating api...'
        directory '.', '.'
        say 'Done!', :green
      end
    end
  end
end
