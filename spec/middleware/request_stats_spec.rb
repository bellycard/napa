require 'spec_helper'
require 'napa/middleware/request_stats'

describe Napa::Middleware::RequestStats do
  before do
    # Delete any prevous instantiations of the emitter and set valid statsd env vars
    Napa::Stats.emitter = nil
    ENV['STATSD_HOST'] = 'localhost'
    ENV['STATSD_PORT'] = '8125'
  end

  it 'should send the api_response_time' do
    expect(Napa::Stats.emitter).to receive(:timing).with('response_time', an_instance_of(Float))
    expect(Napa::Stats.emitter).to receive(:timing).with('path.get.test.path.response_time', an_instance_of(Float))
    app = ->(_env) { [200, { 'Content-Type' => 'application/json' }, Array.new] }
    middleware = Napa::Middleware::RequestStats.new(app)
    env = Rack::MockRequest.env_for('/test/path')
    middleware.call(env)
  end

end
