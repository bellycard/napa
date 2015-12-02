require 'thor'
require 'active_support/core_ext/string'

module Napa
  module CLI
    class Base < Thor
      include Thor::Actions

      source_root File.expand_path('../../templates/new', __FILE__)
      DESC = 'Preconfigure for selected database (options: mysql/postgres/pg)'
      option :database, default: 'mysql', aliases: '-d', desc: DESC

      desc 'new <NAME> [PATH]', 'Create a new Napa application'
      def new(name, path = nil)
        say 'Generating scaffold...'

        @name = name
        @path = path

        @database_gem       = postgres? ? 'pg'         : 'mysql2'
        @database_adapter   = postgres? ? 'postgresql' : 'mysql2'
        @database_encoding  = postgres? ? 'unicode'    : 'utf8'
        @database_user      = postgres? ? ''           : 'root'

        directory '.', (path || name)

        say 'Done!', :green
      end

      no_commands do

        attr_reader :name, :path
        alias_method :app_name, :name
        alias_method :app_path, :path

        def postgres?
          %w(pg postgres).include?(options[:database])
        end

      end
    end
  end
end
