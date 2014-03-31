module Napa
  class Middleware
    class AppMonitor
      def initialize(app)
        @app = app
      end

      def call(env)
        if ["/health", "/health.json"].include? env['REQUEST_PATH']
          [200, { 'Content-type' => 'application/json' }, [Napa::Identity.health.to_json]]
        else
          @app.call(env)
        end
      end
    end
  end
end
