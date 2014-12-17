module Napa
  module StatsDTimer
    def report_time(timer_name, sample_rate: 1)
      if (Time.now.to_f * 1000).to_i % sample_rate == 0
        start_time = Time.now
        yield
        response_time = (Time.now - start_time) * 1000 # statsd reports timers in milliseconds
        Napa::Stats.emitter.timing(timer_name, response_time)
      else
        yield
      end
    end

    module ClassMethods
      def report_time(timer_name, sample_rate: 1)
        new.report_time(timer_name, sample_rate: sample_rate) do
          yield
        end
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end
end
