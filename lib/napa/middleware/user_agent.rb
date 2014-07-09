module Napa
  class Middleware
    class UserAgent
      def initialize(app)
        @app = app
      end

      def call(env)
        status, headers, bodies = @app.call(env)

        headers['User-Agent'] = "#{Napa::Identity.name}/#{Napa::Identity.revision}"

        [status, headers, bodies]
      end
    end
  end
end
