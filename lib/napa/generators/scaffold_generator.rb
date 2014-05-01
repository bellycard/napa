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

        @database_gem       = ['pg','postgres'].include?(options[:database]) ? 'pg' : 'mysql2'
        @database_adapter   = ['pg','postgres'].include?(options[:database]) ? 'postgresql' : 'mysql2'
        @database_encoding  = ['pg','postgres'].include?(options[:database]) ? 'unicode' : 'utf8'
        @database_user      = ['pg','postgres'].include?(options[:database]) ? '' : 'root'

        directory ".", (app_path || app_name)

        say 'Done!', :green
      end
    end
  end
end
