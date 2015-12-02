require 'statsd'
module Napa
  class Stats
    class << self
      attr_writer :emitter

      def emitter
        unless @emitter
          # Log an error if StatsD settings are not configured
          message = 'StatsD host and port not configured in environment variables, using default settings'
          Napa::Logger.logger.warn message unless ENV['STATSD_HOST'] && ENV['STATSD_PORT']

          # Create a new StatsD emitter with the service name as the namespace
          # Defaults to localhost port 8125 if env vars are nil
          @emitter = Statsd.new(ENV['STATSD_HOST'], ENV['STATSD_PORT']).tap { |sd| sd.namespace = namespace }
        end
        @emitter
      end

      def namespace
        environment = ENV['RACK_ENV'] || 'development'

        if ENV['STATSD_API_KEY'].present?
          "#{ENV['STATSD_API_KEY']}.#{Napa::Identity.name}.#{environment}"
        else
          "#{Napa::Identity.name}.#{ environment }"
        end
      end

      def path_to_key(method, path)
        # split the path on forward slash
        # remove any elements that are empty
        # replace any number strings with _
        # join all parts with a .
        # prepend with the method
        # downcase the whole thing
        "#{method}.#{ path.split(/\//).reject { |p| p.empty? }.map { |p| p.gsub(/\d+/, '_') }.join('.') }".downcase
      end
    end
  end
end
