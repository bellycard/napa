require 'spec_helper'
require 'napa/logger/logger'

describe Napa::Logger do
  describe '#request' do
    it 'calls into basic_request_format if format is :basic' do
      expect(Napa::Logger).to receive(:basic_request_format)
      allow(Napa::Logger).to receive_message_chain(:config, :format).and_return(:basic)
      Napa::Logger.request({})
    end

    it 'calls into hash_request_format if format is not :basic' do
      expect(Napa::Logger).to receive(:hash_request_format)
      allow(Napa::Logger).to receive_message_chain(:config, :format).and_return(:json)
      Napa::Logger.request({})
    end
  end

  describe '#basic_request_format' do
    it 'returns the request data in a key/value string' do
      data = {
        foo: 123,
        bar: 234
      }
      Napa::Logger.basic_request_format(data)

      expect(request).to eq('foo=123 bar=234')
    end
  end

  describe '#hash_request_format' do
    it 'returns the hash nested under the "request" key' do
      data = {
        foo: 123,
        bar: 234
      }
      Napa::Logger.hash_request_format(data)

      expect(request[:request][:foo]).to eq(123)
      expect(request[:request][:bar]).to eq(234)
    end
  end

  describe '#response' do
    it 'calls into basic_response_format if format is :basic' do
      expect(Napa::Logger).to receive(:basic_response_format)
      allow(Napa::Logger).to receive_message_chain(:config, :format).and_return(:basic)
      Napa::Logger.response('foo', 'bar', 'baz')
    end

    it 'calls into hash_response_format if format is not :basic' do
      expect(Napa::Logger).to receive(:hash_response_format)
      allow(Napa::Logger).to receive_message_chain(:config, :format).and_return(:json)
      Napa::Logger.response('foo', 'bar', 'baz')
    end
  end

  describe '#basic_response_format' do
    it 'returns the response data in a key/value string' do
      Napa::Logger.basic_response_format('foo', 'bar', ['baz'])

      expect(response).to eq('status=foo headers=bar response=baz')
    end
  end

  describe '#hash_response_format' do
    it 'returns response in the expected format' do
      response = Napa::Logger.hash_response_format('foo', 'bar', 'baz')

      expect(response[:response][:status]).to eq('foo')
      expect(response[:response][:headers]).to eq('bar')
      expect(response[:response][:response]).to eq('baz')
    end
  end
end
