if defined?(Grape)
  module Grape
    module ErrorFormatter
      module Json
        class << self
          def call(message, backtrace, options = {}, _env = nil)
            result = message.is_a?(Napa::JsonError) ? message : Napa::JsonError.new(:api_error, message)

            if (options[:rescue_options] || {})[:backtrace] && backtrace && !backtrace.empty?
              result = result.to_h.merge(backtrace: backtrace)
            end
            MultiJson.dump(result)
          end
        end
      end
    end
  end
end
