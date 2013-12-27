require 'statsd'
module Napa
  class Stats
    class << self
      def emitter=(emitter)
        @emitter = emitter
      end

      def emitter
        unless @emitter
          # Log an error if StatsD settings are not configured
          message = 'StatsD host and port not configured in environment variables, using default settings'
          Napa::Logger.logger.warn message unless ENV['STATSD_HOST'] && ENV['STATSD_PORT']

          # Create a new StatsD emitter with the service name as the namespace
          # Defaults to localhost port 8125 if env vars are nil
          @emitter = Statsd.new(ENV['STATSD_HOST'], ENV['STATSD_PORT']).tap { |sd| sd.namespace = Napa::Identity.name }
        end
        @emitter
      end
    end
  end
end
