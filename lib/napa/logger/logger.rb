module Napa
  class Logger
    class << self
      def name
        [Napa::Identity.name, Napa::LogTransaction.id].join('-')
      end

      def logger=(logger)
        @logger = logger
      end

      def logger
        unless @logger
          Logging.appenders.stdout(
            'stdout',
            layout: Logging.layouts.json
          )
          Logging.appenders.file(
            "log/#{Napa.env}.log",
            layout: Logging.layouts.json
          )

          @logger = Logging.logger["[#{name}]"]
          @logger.add_appenders 'stdout' unless Napa.env.test?
          @logger.add_appenders "log/#{Napa.env}.log"
        end

        @logger
      end

      def response(status, headers, body)
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
