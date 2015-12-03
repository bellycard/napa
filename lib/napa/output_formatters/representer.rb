require 'roar/decorator'
require 'roar/version'

if Roar::VERSION >= '1.0.0'
  require 'roar/json'
  require 'roar/coercion'
else
  require 'roar/representer/json'
  require 'roar/representer/feature/coercion'
end

module Napa
  class Representer < Roar::Decorator
    include Coercion

    if Roar::VERSION >= '1.0.0'
      include Roar::JSON
    else
      include Roar::Representer::JSON
    end

    property :object_type, getter: ->(*) { self.class.name.underscore }
  end
end
