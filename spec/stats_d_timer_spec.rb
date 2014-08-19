require 'spec_helper'
require 'napa/stats_d_timer'

class FooTimer
  include Napa::StatsDTimer
end

describe Napa::StatsDTimer do
  before do
    # Delete any prevous instantiations of the emitter
    Napa::Stats.emitter = nil
    # Stub out logging since there is no log to output to
    allow(Napa::Logger).to receive_message_chain(:logger, :warn)
  end

  it 'logs a timing event based on how long the block takes' do
    expect(Napa::Stats.emitter).to receive(:timing).with('foo', an_instance_of(Float))
    FooTimer.report_time('foo') do
      sleep(0.1)
    end
  end

end
