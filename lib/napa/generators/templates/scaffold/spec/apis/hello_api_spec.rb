require 'spec_helper'

def app
  HelloService::API
end

describe HelloService::API do
  include Rack::Test::Methods

  describe 'GET /hello' do
    it 'returns a hello world message' do
      get '/hello'
      expect(last_response.body).to eq({ message: 'Hello Wonderful World!' }.to_json)
    end
  end

end
