module Napa
  class Logger
    class << self
      def name
        [Napa::Identity.name, Napa::LogTransaction.id].join('-')
      end

      def config=(config)
        @config = config
      end

      def config
        @config ||= Napa::Logger::Configuration.new
      end

      def logger=(logger)
        @logger = logger
      end

      def logger
        unless @logger
          @logger = Logging.logger["[#{name}]"]
          Napa::Logger::Output::Stdout.new
          Napa::Logger::Output::File.new
        end

        @logger
      end

      def basic_request_format(data)
        data.map{|k,v| "#{k}=#{v}"}.join(' ')
      end

      def request_format(data)
        { request: data }
      end

      def basic_response_format(status, headers, body)
        {
          status:   status,
          headers:  headers,
          response: body.first
        }.map{|k,v| "#{k}=#{v}"}.join(' ')
      end

      def response_format(status, headers, body)
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
