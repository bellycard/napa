require "napa/cli/generate/api"
require "napa/cli/generate/readme"
require "napa/cli/migration"

module Napa
  module CLI
    class Generate < Thor

      register(
        Migration,
        'migration',
        'migration <NAME> [field[:type][:index] field[:type][:index]]',
        'Create a Database Migration'
      )

    end
  end
end
