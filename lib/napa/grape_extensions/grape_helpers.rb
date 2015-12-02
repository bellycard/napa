module Napa
  module GrapeHelpers
    def represent(data, with: nil, **args)
      fail ArgumentError, ':with option is required' if with.nil?

      if data.respond_to?(:map)
        return { data: data.map { |item| with.new(item).to_hash(args) } }
      else
        return { data: with.new(data).to_hash(args) }
      end
    end

    def present_error(code, message = '', reasons = {})
      Napa::JsonError.new(code, message, reasons)
    end

    def permitted_params(options = {})
      options = { include_missing: false }.merge(options)
      declared(params, options)
    end

    # extend all endpoints to include this
    Grape::Endpoint.send :include, self if defined?(Grape)
    # rails 4 controller concern
    extend ActiveSupport::Concern if defined?(Rails)
  end
end
