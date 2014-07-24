require 'spec_helper'
require 'napa/stats'

describe Napa::Stats do
  before do
    # Delete any prevous instantiations of the emitter
    Napa::Stats.emitter = nil
    # Stub out logging since there is no log to output to
    Napa::Logger.stub_chain(:logger, :warn)
  end

  it 'should log an error if StatsD env variables are not configured' do
    ENV['STATSD_HOST'] = nil
    ENV['STATSD_PORT'] = nil
    message = 'StatsD host and port not configured in environment variables, using default settings'
    Napa::Logger.logger.should_receive(:warn).with(message)
    Napa::Stats.emitter
  end

  it 'should default statsd to localhost port 8125 if env vars are not specified' do
    ENV['STATSD_HOST'] = nil
    ENV['STATSD_PORT'] = nil
    expect(Napa::Stats.emitter.host).to eq('127.0.0.1')
    expect(Napa::Stats.emitter.port).to eq(8125)
  end

  it 'should return a StatsD client object' do
    expect(Napa::Stats.emitter.class.name).to eq('Statsd')
  end

  it 'the namespace of the StatsD client object should equal the service name' do
    ENV['SERVICE_NAME'] = 'my-service'
    expect(Napa::Stats.emitter.namespace).to eq("my-service.#{ENV['SERVICE_NAME']}")
  end

  it 'should use env variables to set statsd host and port' do
    ENV['STATSD_HOST']  = 'localhost'
    ENV['STATSD_PORT']  = '9000'
    expect(Napa::Stats.emitter.host).to eq('localhost')
    expect(Napa::Stats.emitter.port).to eq('9000')
  end

  describe '#namespace' do
    it 'prepends the namespace with the STATSD_API_KEY if present'
    it 'does not include the STATSD_API_KEY if empty'
  end
end
