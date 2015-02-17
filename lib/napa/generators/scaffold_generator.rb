require 'thor'
require 'active_support/core_ext/string'

module Napa
  module Generators
    class ScaffoldGenerator < Thor::Group

      include Thor::Actions

      source_root "#{File.dirname(__FILE__)}/templates/scaffold"

      argument :app_name
      argument :app_path, optional: true
      class_option :database, default: 'mysql', aliases: '-d', desc: 'Preconfigure for selected database (options: mysql/postgres/pg)'

      def generate
        say 'Generating scaffold...'

        @database_gem       = postgres? ? 'pg'         : 'mysql2'
        @database_adapter   = postgres? ? 'postgresql' : 'mysql2'
        @database_encoding  = postgres? ? 'unicode'    : 'utf8'
        @database_user      = postgres? ? ''           : 'root'

        directory ".", (app_path || app_name)

        say 'Done!', :green
      end

      no_commands do

        def postgres?
          %w[pg postgres].include?(options[:database])
        end

      end

    end
  end
end
