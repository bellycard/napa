require 'thor'
require 'active_support/core_ext/string'

module Napa
  module Generators
    class ScaffoldGenerator < Thor::Group
      include Thor::Actions

      source_root "#{File.dirname(__FILE__)}/templates/scaffold"

      argument :app_name
      argument :app_path, optional: true

      def generate
        say 'Generating scaffold...'

        directory ".", (app_path || app_name)

        say 'Done!', :green
      end
    end
  end
end
