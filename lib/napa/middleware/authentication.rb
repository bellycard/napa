module Napa
  class Middleware
    class Authentication
      def initialize(app)
        @app = app
        @old_allowed_passwords = []
        @allowed_header_passwords = []

        if ENV['HEADER_PASSWORDS']
          @old_allowed_passwords += ENV['HEADER_PASSWORDS'].split(',').map(&:strip).freeze
        end

        if ENV['ALLOWED_HEADER_PASSWORDS']
          @allowed_header_passwords += ENV['ALLOWED_HEADER_PASSWORDS'].split(',').map(&:strip).freeze
        end
      end

      def call(env)
        if authenticated_request?(env)
          @app.call(env)
        else
          unless @old_allowed_passwords.blank? && @allowed_header_passwords.blank?
            error_response = Napa::JsonError.new('bad_password', 'bad password').to_json
          else
            error_response = Napa::JsonError.new('not_configured', 'password not configured').to_json
          end

          [401, { 'Content-type' => 'application/json' }, Array.wrap(error_response)]
        end
      end

      def authenticated_request?(env)
        return if @old_allowed_passwords.blank? && @allowed_header_passwords.blank?

        if env['HTTP_PASSWORDS'].present?
          possible_passwords = env['HTTP_PASSWORDS'].to_s.split(',')
          (@allowed_header_passwords & possible_passwords).any?
        else
          @old_allowed_passwords.include? env['HTTP_PASSWORD']
        end
      end
    end
  end
end
