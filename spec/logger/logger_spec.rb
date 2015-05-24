require 'spec_helper'
require 'napa/logger/logger'

describe Napa::Logger do
  describe '#basic_request_format' do
    it 'returns the request data in a key/value string' do
      data = {
        foo: 123,
        bar: 234
      }
      request = Napa::Logger.basic_request_format(data)

      expect(request).to eq("foo=123 bar=234")
    end
  end

  describe '#request_format' do
    it 'returns the hash nested under the "request" key' do
      data = {
        foo: 123,
        bar: 234
      }
      request = Napa::Logger.request_format(data)

      expect(request[:request][:foo]).to eq(123)
      expect(request[:request][:bar]).to eq(234)
    end
  end

  describe '#basic_response_format' do
    it 'returns the response data in a key/value string' do
      response = Napa::Logger.basic_response_format('foo', 'bar', ['baz'])

      expect(response).to eq("status=foo headers=bar response=baz")
    end
  end

  describe '#response_format' do
    it 'returns response in the expected format' do
      response = Napa::Logger.response_format('foo', 'bar', 'baz')

      expect(response[:response][:status]).to eq('foo')
      expect(response[:response][:headers]).to eq('bar')
      expect(response[:response][:response]).to eq('baz')
    end
  end
end
