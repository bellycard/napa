require 'spec_helper'
require 'napa/logger/logger'

describe Napa::Logger do
  context '#response' do
    it 'returns response in the expected format' do
      response = Napa::Logger.response('foo', 'bar', 'baz')

      expect(response[:response][:status]).to eq('foo')
      expect(response[:response][:headers]).to eq('bar')
      expect(response[:response][:response]).to eq('baz')
    end
  end
end
