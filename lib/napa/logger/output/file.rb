module Napa
  class Logger
    class Output
      class File
        def initialize(filename = "log/#{Napa.env}.log")
          return unless enable?
          Logging.appenders.file(filename, options)
          Napa::Logger.logger.add_appenders filename
        end

        def options
          {}.tap do |o|
            o[:layout] = Logging.layouts.json if Napa::Logger.config.format == :json
            o[:layout] = Logging.layouts.yaml if Napa::Logger.config.format == :yaml
          end
        end

        def enable?
          Napa::Logger.config.output.include?(:file)
        end
      end
    end
  end
end
