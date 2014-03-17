require 'thor'
require 'napa/generators'
require 'napa/version'

module Napa
  class CLI
    class Generate < Thor
      register(
        Generators::ApiGenerator,
        'api',
        'api <api_name>',
        'Create a Grape API, Model and Entity'
      )

      register(
        Generators::MigrationGenerator,
        'migration',
        'migration <migration_name>',
        'Create a Database Migration'
      )
    end
  end

  class CLI
    class Base < Thor
      desc "version", "Shows the Napa version number"
      def version
        say Napa::VERSION
      end

      register(
        Generators::ScaffoldGenerator,
        'new',
        'new <app_name> [app_path]',
        'Create a scaffold for a new Napa service'
      )

      desc "generate api <api_name>", "Create a Grape API, Model and Entity"
      subcommand "generate", Napa::CLI::Generate

      desc "generate migration <migration_name>", "Create a Database Migration"
      subcommand "generate", Napa::CLI::Generate
    end
  end
end
