module Napa
  class Middleware
    class Logger
      def initialize(app)
        @app = app
      end

      def call(env)
        # log the request
        Napa::Logger.logger.debug format_request(env)

        # process the request
        status, headers, body = @app.call(env)

        # log the response
        Napa::Logger.logger.debug format_response(status, headers, body)

        # return the results
        [status, headers, body]
      ensure
        # Clear the transaction id after each request
        Napa::LogTransaction.clear
      end

      private

        def format_request(env)
          request = Rack::Request.new(env)
          params =  request.params
          begin
            params = JSON.parse(request.body.read) if env['CONTENT_TYPE'] == 'application/json'
          rescue
            # do nothing, params is already set
          end

          request_data = {
            method:           env['REQUEST_METHOD'],
            path:             env['PATH_INFO'],
            query:            env['QUERY_STRING'],
            host:             Napa::Identity.hostname,
            pid:              Napa::Identity.pid,
            revision:         Napa::Identity.revision,
            params:           params
          }
          request_data[:user_id] = current_user.try(:id) if defined?(current_user)
          { request: request_data }
        end

        def format_response(status, headers, body)
          response_body = nil
          begin
            response_body = body.respond_to?(:body) ? body.body.map { |r| r } : nil
          rescue
            response_body = body.inspect
          end

          Napa::Logger.response(status, headers, response_body)
        end
    end
  end
end
