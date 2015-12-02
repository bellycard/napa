require 'napa/cli/base/console'
require 'napa/cli/base/deploy'
require 'napa/cli/base/new'
require 'napa/cli/base/server'
require 'napa/cli/base/version'
require 'napa/cli/generate'

module Napa
  module CLI
    class Base < Thor
      desc 'generate [COMMAND]', 'Generate new code'
      subcommand 'generate', Napa::CLI::Generate
    end
  end
end
