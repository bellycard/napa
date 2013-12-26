require 'spec_helper'
require 'napa/middleware/request_stats'

describe Napa::Middleware::RequestStats do
  before do
    ENV['STATSD_HOST'] = 'localhost'
    ENV['STATSD_PORT'] = '8125'
  end

  it 'should increment api_requests counter' do
    Napa::Stats.emitter.should_receive(:increment).with('api_requests')

    app = lambda { |env| [200, { 'Content-Type' => 'application/json' }, Array.new] }
    middleware = Napa::Middleware::RequestStats.new(app)
    env = Rack::MockRequest.env_for('/test')
    middleware.call(env)
  end

  it 'should send the api_response_time' do
    Napa::Stats.emitter.should_receive(:timing).with('api_response_time', an_instance_of(Float))

    app = lambda { |env| [200, { 'Content-Type' => 'application/json'}, Array.new] }
    middleware = Napa::Middleware::RequestStats.new(app)
    env = Rack::MockRequest.env_for('/test')
    middleware.call(env)
  end

end
