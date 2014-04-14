module Napa
  module GrapeHelpers
    def represent(data, with: nil, **args)
      raise ArgumentError.new(":with option is required") if with.nil?

      if data.respond_to?(:to_a)
        return { data: data.each{ |item| with.new(item).to_hash(args) } }
      else
        return { data: with.new(data).to_hash(args)}
      end
    end

    def present_error(code, message = '')
      Napa::JsonError.new(code, message)
    end

    # extend all endpoints to include this
    Grape::Endpoint.send :include, self
  end
end
