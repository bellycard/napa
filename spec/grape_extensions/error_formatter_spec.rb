require 'spec_helper'
require 'napa/grape_extensions/error_formatter'

describe Grape::ErrorFormatter::Json do
  context '#call' do
    it 'returns an api_error for plain error messages' do
      error = Grape::ErrorFormatter::Json.call('test message', nil)
      parsed = JSON.parse(error)
      parsed['error']['code'].should eq('api_error')
      parsed['error']['message'].should eq('test message')
    end

    it 'returns a specified error when given a Napa::JsonError object' do
      json_error = Napa::JsonError.new(:foo, 'bar')
      error = Grape::ErrorFormatter::Json.call(json_error, nil)
      parsed = JSON.parse(error)
      parsed['error']['code'].should eq('foo')
      parsed['error']['message'].should eq('bar')
    end
  end
end