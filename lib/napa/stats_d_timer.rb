module Napa
  module StatsDTimer
    def report_time(timer_name)
      start_time = Time.now
      yield
      response_time = Time.now - start_time
      Napa::Stats.emitter.timing(timer_name, response_time)
    end

    module ClassMethods
      def report_time(timer_name)
        new.report_time(timer_name) do
          yield
        end
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
