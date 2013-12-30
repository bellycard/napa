module Napa
  class Middleware
    class RequestStats
      def initialize(app)
        @app = app
      end

      def call(env)
        # Mark the request time
        start = Time.now

        # Process the request
        status, headers, body = @app.call(env)

        # Mark the response time
        stop = Time.now

        # Calculate total response time
        response_time = stop - start

        # Emit stats to StatsD
        Napa::Stats.emitter.increment('api_requests')
        Napa::Stats.emitter.timing('api_response_time', response_time)

        # Return the results
        [status, headers, body]
      end
    end
  end
end
