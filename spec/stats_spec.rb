require 'spec_helper'
require 'napa/stats'

describe Napa::Stats do
  before do
    Napa::Stats.emitter = nil
  end

  it 'should raise an error if StatsD env variables are not configured' do
    ENV['STATSD_HOST'] = nil
    ENV['STATSD_PORT'] = nil
    expect{Napa::Stats.emitter}.to raise_error
  end

  it 'should return a StatsD client object' do
    ENV['STATSD_HOST'] = 'localhost'
    ENV['STATSD_PORT'] = '8125'
    expect(Napa::Stats.emitter.class.name).to eq('Statsd')
  end

  it 'the namespace of the StatsD client object should equal the service name' do
    ENV['STATSD_HOST']  = 'localhost'
    ENV['STATSD_PORT']  = '8125'
    ENV['SERVICE_NAME'] = 'my-service'
    expect(Napa::Stats.emitter.namespace).to eq('my-service')
  end
end
