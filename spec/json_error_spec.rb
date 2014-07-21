require 'spec_helper'
require 'napa/json_error'

describe Napa::JsonError do
  context '#to_json' do
    it 'returns a json hash with the error data' do
      error = Napa::JsonError.new(:code, 'message').to_json
      parsed = JSON.parse(error)

      expect(parsed['error']['code']).to eq('code')
      expect(parsed['error']['message']).to eq('message')
    end
  end
end
