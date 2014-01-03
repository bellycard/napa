require 'thor'
require 'napa/generators'

module Napa
  class CLI < Thor
    register(Generators::ScaffoldGenerator, 'new', 'new <app_name> [app_path]',
             'Create a new Napa scaffold')
    register(Generators::ApiGenerator, 'generate', 'api <api_name>',
             'Create a Grape API and model')
  end
end
