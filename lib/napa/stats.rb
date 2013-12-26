require 'statsd'
module Napa
  class Stats
    class << self
      def emitter=(emitter)
        @emitter = emitter
      end

      def emitter
        unless @emitter
          # Raise an error if StatsD settings are not configured
          fail 'statsd_not_configured' unless ENV['STATSD_HOST'] && ENV['STATSD_PORT']

          # Create a new StatsD emitter with the service name as the namespace
          @emitter = Statsd.new(ENV['STATSD_HOST'], ENV['STATSD_PORT'])
                           .tap { |sd| sd.namespace = Napa::Identity.name }
        end
        @emitter
      end
    end
  end
end
