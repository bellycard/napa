require 'roar/decorator'
require 'roar/representer/json'
require 'roar/representer/feature/coercion'

module Napa
  class Representer < Roar::Decorator
    include Roar::Representer::JSON
    include ::Representable::Coercion

    property :object_type, getter: ->(*) { self.class.name.underscore }
  end
end
