module Napa
  class Logger
    attr_writer :config, :logger

    class << self
      def name
        [Napa::Identity.name, Napa::LogTransaction.id].join('-')
      end

      def config
        @config ||= Napa::Logger::Configuration.new
      end

      def logger
        unless @logger
          @logger = Logging.logger["[#{name}]"]
          Napa::Logger::Output::Stdout.new
          Napa::Logger::Output::File.new
        end

        @logger
      end

      def request(data)
        if Napa::Logger.config.format == :basic
          Napa::Logger.basic_request_format(data)
        else
          Napa::Logger.hash_request_format(data)
        end
      end

      def basic_request_format(data)
        data.map { |k, v| "#{k}=#{v}" }.join(' ')
      end

      def hash_request_format(data)
        { request: data }
      end

      def response(status, headers, body)
        if Napa::Logger.config.format == :basic
          Napa::Logger.basic_response_format(status, headers, body)
        else
          Napa::Logger.hash_response_format(status, headers, body)
        end
      end

      def basic_response_format(status, headers, body)
        {
          status:   status,
          headers:  headers,
          response: body.first
        }.map { |k, v| "#{k}=#{v}" }.join(' ')
      end

      def hash_response_format(status, headers, body)
        { response:
          {
            status:   status,
            headers:  headers,
            response: body
          }
        }
      end
    end
  end
end
