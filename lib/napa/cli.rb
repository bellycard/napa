require 'thor'
require 'napa/generators'

module Napa
  class CLI < Thor
    desc "version", "Shows the Napa version number"
    def version
      say Napa::VERSION
    end

    register(Generators::ScaffoldGenerator, 'new', 'new <app_name> [app_path]',
             'Create a new Napa scaffold')
    register(Generators::ApiGenerator, 'generate', 'generate api <generator_name> <name>',
             'Create a Grape API and model')
  end
end
