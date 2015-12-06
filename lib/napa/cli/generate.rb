require 'napa/cli/generate/api'
require 'napa/cli/generate/readme'
require 'napa/cli/migration'
require 'napa/cli/model'

module Napa
  module CLI
    class Generate < Thor
      register(
        Migration,
        'migration',
        'migration <NAME> [field[:type][:index] field[:type][:index]]',
        'Create a Database Migration'
      )

      register(
        Model,
        'model',
        'model <NAME> [field[:type][:index] field[:type][:index]] [options]',
        'Create a Model, including its database migration and test scaffolding'
      )
    end
  end
end
