require 'thor'
require 'napa/generators'

module Napa
  module CLI

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
        'migration <migration_name> [field[:type][:index] field[:type][:index]]',
        'Create a Database Migration'
      )

      register(
        Generators::ReadmeGenerator,
        'readme',
        'readme',
        'Create a formatted README'
      )
    end

  end
end
