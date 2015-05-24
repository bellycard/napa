require 'napa/param_sanitizer'

module Napa
  class Middleware
    class Logger
      include Napa::ParamSanitizer

      def initialize(app)
        @app = app
      end

      def call(env)
        # log the request and set the log level from the configuration
        Napa::Logger.logger.send(Napa::Logger.config.request_level, format_request(env))

        # process the request
        status, headers, body = @app.call(env)

        # log the response and set the log level from the configuration
        Napa::Logger.logger.send(Napa::Logger.config.response_level, format_response(status, headers, body))

        # return the results
        [status, headers, body]
      ensure
        # Clear the transaction id after each request
        Napa::LogTransaction.clear
      end

      private

        def format_request(env)
          request = Rack::Request.new(env)
          params  = request.params

          begin
            params = JSON.parse(request.body.read) if env['CONTENT_TYPE'] == 'application/json'
          rescue
            # do nothing, params is already set
          end

          request_data = {
            method:           request.request_method,
            path:             request.path_info,
            query:            filtered_query_string(request.query_string),
            host:             Napa::Identity.hostname,
            pid:              Napa::Identity.pid,
            revision:         Napa::Identity.revision,
            params:           filtered_parameters(params),
            remote_ip:        request.ip
          }
          request_data[:user_id] = current_user.try(:id) if defined?(current_user)

          if Napa::Logger.config.format == :basic
            Napa::Logger.basic_request_format(request_data)
          else
            Napa::Logger.request_format(request_data)
          end
        end

        def format_response(status, headers, body)
          response_body = nil
          begin
            response_body = body.respond_to?(:body) ? body.body.map { |r| r } : nil
          rescue
            response_body = body.inspect
          end

          if Napa::Logger.config.format == :basic
            Napa::Logger.basic_response_format(status, headers, response_body)
          else
            Napa::Logger.response_format(status, headers, response_body)
          end
        end
    end
  end
end
