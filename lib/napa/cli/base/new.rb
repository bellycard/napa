require 'thor'
require 'active_support/core_ext/string'

module Napa
  module CLI
    class Base < Thor

      include Thor::Actions

      source_root File.expand_path("../../templates/new", __FILE__)

      option :database, default: 'mysql', aliases: '-d', desc: 'Preconfigure for selected database (options: mysql/postgres/pg)'

      desc "new <NAME> [PATH]", "Create a new Napa application"
      def new(name, path = nil)
        say 'Generating scaffold...'

        @name = name
        @path = path

        @database_gem       = postgres? ? 'pg'         : 'mysql2'
        @database_adapter   = postgres? ? 'postgresql' : 'mysql2'
        @database_encoding  = postgres? ? 'unicode'    : 'utf8'
        @database_user      = postgres? ? ''           : 'root'

        directory ".", (path || name)

        say 'Done!', :green
      end

      no_commands do

        def app_name
          @name
        end

        def app_path
          @path
        end

        def postgres?
          %w[pg postgres].include?(options[:database])
        end

      end

    end
  end
end
