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

      desc 'console [environment]', 'Start the Napa console'
      options aliases: 'c'
      def console(environment = nil)
        ENV['RACK_ENV'] = environment || 'development'

        require 'racksh/init'

        begin
          require "pry"
          interpreter = Pry
        rescue LoadError
          require "irb"
          require "irb/completion"
          interpreter = IRB
          # IRB uses ARGV and does not expect these arguments.
          ARGV.delete('console')
          ARGV.delete(environment) if environment
        end

        Rack::Shell.init

        $0 = "#{$0} console"
        interpreter.start
      end

      register(
        Generators::ScaffoldGenerator,
        'new',
        'new <app_name> [app_path]',
        'Create a scaffold for a new Napa service'
      )

      desc "generate api <api_name>", "Create a Grape API, Model and Representer"
      subcommand "generate api", Napa::CLI::Generate

      desc "generate migration <migration_name>", "Create a Database Migration"
      subcommand "generate", Napa::CLI::Generate
    end
  end
end
