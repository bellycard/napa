module Napa
  class Middleware
    class DatabaseStats
      def initialize(app)
        @app = app
      end

      def call(env)
        require 'napa/active_record_extensions/notifications_subscriber'
        status, headers, body = @app.call(env)
        [status, headers, body]
      end
    end
  end
end
