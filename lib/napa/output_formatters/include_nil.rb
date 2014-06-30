# include this in your representer, and you will always return all defined keys (even if their value is nil)
module Napa
  module Representable
    module IncludeNil
      def self.included base
        base.extend ClassMethods
      end

      module ClassMethods
        def property(name, options={}, &block)
          super(name, options.merge(render_nil: true), &block)
        end
      end
    end
  end
end
