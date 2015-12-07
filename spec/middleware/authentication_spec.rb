require 'spec_helper'
require 'napa/middleware/authentication'
require 'pry'

describe Napa::Identity do
  let(:app) { ->(_env) { [200, { 'Content-Type' => 'application/json' }, Array.new] } }
  let(:middleware) { Napa::Middleware::Authentication.new(app) }

  context 'using HEADER_PASSWORDS' do
    before do
      ENV['HEADER_PASSWORDS'] = 'foo'
    end
    context 'an authenticated request' do
      it 'allows the request to continue if given a correct password header' do
        env = Rack::MockRequest.env_for('/test', 'HTTP_PASSWORD' => 'foo')
        status, _headers, _body = middleware.call(env)

        expect(status).to eq(200)
      end

      it 'allows the request if given a correct password header and a Passwords header' do
        env = Rack::MockRequest.env_for('/test', 'HTTP_PASSWORD' => 'foo', 'HTTP_PASSWORDS' => 'foo,bar')
        status, _headers, _body = middleware.call(env)

        expect(status).to eq(200)
      end
    end

    context 'a failed authentication request' do
      it 'returns an error message if the Password header is not supplied' do
        env = Rack::MockRequest.env_for('/test')
        status, _headers, body = middleware.call(env)

        expect(status).to eq(401)
        expect(body).to eq([Napa::JsonError.new('bad_password', 'bad password').to_json])
      end

      it 'returns an error message if an incorrect Password header is supplied' do
        env = Rack::MockRequest.env_for('/test', 'HTTP_PASSWORD' => 'incorrect')
        status, _headers, body = middleware.call(env)

        expect(status).to eq(401)
        expect(body).to eq([Napa::JsonError.new('bad_password', 'bad password').to_json])
      end

      it 'returns an error message if an incorrect Password header is supplied, and a Passwords header is there' do
        env = Rack::MockRequest.env_for('/test', 'HTTP_PASSWORD' => 'incorrect', 'HTTP_PASSWORDS' => 'foo,bar')
        status, _headers, body = middleware.call(env)

        expect(status).to eq(401)
        expect(body).to eq([Napa::JsonError.new('bad_password', 'bad password').to_json])
      end

      it 'returns an error message if HEADER_PASSWORDS is not configured' do
        ENV['HEADER_PASSWORDS'] = nil

        env = Rack::MockRequest.env_for('/test', 'HTTP_PASSWORD' => 'incorrect')
        status, _headers, body = middleware.call(env)

        expect(status).to eq(401)
        expect(body).to eq([Napa::JsonError.new('not_configured', 'password not configured').to_json])
      end
    end
  end

  context 'using ALLOWED_HEADER_PASSWORDS' do
    before do
      ENV['ALLOWED_HEADER_PASSWORDS'] = 'foo,bar'
    end

    context 'an authenticated request' do
      it 'allows the request to continue if given a correct password header' do
        env = Rack::MockRequest.env_for('/test', 'HTTP_PASSWORDS' => 'foo')
        status, _headers, _body = middleware.call(env)

        expect(status).to eq(200)
      end

      it 'allows the request to continue if one password is correct' do
        env = Rack::MockRequest.env_for('/test', 'HTTP_PASSWORDS' => 'foo,baz')
        status, _headers, _body = middleware.call(env)

        expect(status).to eq(200)
      end
    end

    context 'a failed authentication request' do
      it 'returns an error message if the Password header is not supplied' do
        env = Rack::MockRequest.env_for('/test')
        status, _headers, body = middleware.call(env)

        expect(status).to eq(401)
        expect(body).to eq([Napa::JsonError.new('bad_password', 'bad password').to_json])
      end

      it 'returns an error message if an incorrect Password header is supplied' do
        env = Rack::MockRequest.env_for('/test', 'HTTP_PASSWORD' => 'incorrect')
        status, _headers, body = middleware.call(env)

        expect(status).to eq(401)
        expect(body).to eq([Napa::JsonError.new('bad_password', 'bad password').to_json])
      end

      it 'returns an error message if ALLOWED_HEADER_PASSWORDS is not configured' do
        ENV['ALLOWED_HEADER_PASSWORDS'] = nil

        env = Rack::MockRequest.env_for('/test', 'HTTP_PASSWORD' => 'incorrect')
        status, _headers, body = middleware.call(env)

        expect(status).to eq(401)
        expect(body).to eq([Napa::JsonError.new('not_configured', 'password not configured').to_json])
      end
    end
  end
end
