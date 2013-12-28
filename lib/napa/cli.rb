require 'thor'
require 'napa/generators'

module Napa
  class CLI < Thor
    register(Generators::ScaffoldGenerator, 'new', 'new <name> [path]',
             'Create a new Napa scaffold')
  end
end
