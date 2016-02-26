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

        request_data = {}.tap do |h|
          h[:method]      = request.request_method
          h[:path]        = request.path_info
          h[:query]       = filtered_query_string(request.query_string)
          h[:host]        = Napa::Identity.hostname
          h[:pid]         = Napa::Identity.pid
          h[:revision]    = Napa::Identity.revision
          h[:params]      = filtered_parameters(params) unless ENV['SILENCE_REQUEST_PARAMS_LOG'] == 'true'
          h[:remote_ip]   = request.ip
        end

        request_data[:user_id] = current_user.try(:id) if defined?(current_user)

        Napa::Logger.request(request_data)
      end

      def format_response(status, headers, body)
        response_body = body.respond_to?(:body) ? body.body : nil
        Napa::Logger.response(status, headers, response_body)
      end
    end
  end
end
