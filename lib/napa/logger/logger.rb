module Napa
  class Logger
    class << self
      attr_writer :logger
      def name
        [Napa::Identity.name, Napa::LogTransaction.id].join('-')
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
    end
  end
end
