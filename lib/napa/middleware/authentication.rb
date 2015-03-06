module Napa
  class Middleware
    class Authentication
      def initialize(app)
        @app = app

        if ENV['HEADER_PASSWORDS']
          @allowed_passwords = ENV['HEADER_PASSWORDS'].split(',').map { |pw| pw.strip }.freeze
        end
      end

      def call(env)
        if authenticated_request?(env)
          @app.call(env)
        else
          if @allowed_passwords
            error_response = Napa::JsonError.new('bad_password', 'bad password').to_json
          else
            error_response = Napa::JsonError.new('not_configured', 'password not configured').to_json
          end

          [401, { 'Content-type' => 'application/json' }, Array.wrap(error_response)]
        end

      end

      def authenticated_request?(env)
        return if @allowed_passwords.nil?
        possible_passwords = env['HTTP_PASSWORD'].to_s.split(',')
        return if possible_passwords.length > 2
        (@allowed_passwords & possible_passwords).any?
      end
    end
  end
end
