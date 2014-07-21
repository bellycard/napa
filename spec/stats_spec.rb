require 'spec_helper'
require 'napa/stats'

describe Napa::Stats do
  before do
    # Delete any prevous instantiations of the emitter
    Napa::Stats.emitter = nil
    # Stub out logging since there is no log to output to
    allow(Napa::Logger).to receive_message_chain(:logger, :warn)
  end

  it 'should log an error if StatsD env variables are not configured' do
    ENV['STATSD_HOST'] = nil
    ENV['STATSD_PORT'] = nil
    message = 'StatsD host and port not configured in environment variables, using default settings'
    expect(Napa::Logger.logger).to receive(:warn).with(message)
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
    expect(Napa::Stats.emitter.namespace).to eq("my-service.test")
  end

  it 'should use env variables to set statsd host and port' do
    ENV['STATSD_HOST']  = 'localhost'
    ENV['STATSD_PORT']  = '9000'
    expect(Napa::Stats.emitter.host).to eq('localhost')
    expect(Napa::Stats.emitter.port).to eq('9000')
  end

  describe '#namespace' do
    it 'prepends the namespace with the STATSD_API_KEY if present' do
      ENV['STATSD_API_KEY'] = 'foo'
      expect(Napa::Stats.namespace).to eq("#{ENV['STATSD_API_KEY']}.#{Napa::Identity.name}.test")
    end

    it 'does not include the STATSD_API_KEY if empty' do
      ENV['STATSD_API_KEY'] = nil
      expect(Napa::Stats.namespace).to eq("#{Napa::Identity.name}.test")
    end
  end

  describe '#path_to_key' do
    it 'returns the key string with ids removed and parts joined with dots' do
      method = 'GET'
      path = '/foo/123/bar'
      expect(Napa::Stats.path_to_key(method, path)).to eq('get.foo._.bar')

      method = 'POST'
      path = '/foo'
      expect(Napa::Stats.path_to_key(method, path)).to eq('post.foo')
    end
  end
end
