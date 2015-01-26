require 'roar/json'
require 'roar/decorator'
require 'roar/coercion'

module Napa
  class Representer < Roar::Decorator
    include Roar::JSON
    include Roar::Coercion

    property :object_type, getter: lambda { |*| self.class.name.underscore }
  end
end
