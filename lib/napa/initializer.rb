module Napa
  class Initializer
    def self.run
      Napa::Logger.logger.info Napa::GemDependency.log_all if Napa.env.production?
    end
  end
end
