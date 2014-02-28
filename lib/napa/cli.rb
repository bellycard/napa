require 'thor'
require 'napa/generators'
require 'napa/version'

module Napa
  class CLI < Thor
    desc "version", "Shows the Napa version number"
    def version
      say Napa::VERSION
    end

    register(Generators::ScaffoldGenerator, 'new', 'new <app_name> [app_path]',
             'Create a scaffold for a new Napa service')
    register(Generators::ApiGenerator, 'generate:api', 'generate:api <api_name>',
             'Create a Grape API, Model and Entity')
  end
end
