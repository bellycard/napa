require 'roar/decorator'
require 'roar/representer/json'
require 'roar/representer/feature/coercion'

module Napa
  class Representer < Roar::Decorator
    include Roar::Representer::JSON
    include Representable::Coercion
    def self.property(name, options={}, &block)
      super(name, options.merge(render_nil: true), &block)
    end

    property :object_type, getter: lambda { |*| self.class.name.underscore }
  end
end
