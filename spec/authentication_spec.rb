require 'spec_helper'
require 'napa/authentication'

describe Napa::Authentication do
  context '#password_header' do
    it "returns a password hash for the request header" do
      ENV['HEADER_PASSWORD'] = 'foo'
      Napa::Authentication.password_header.class.should eq(Hash)
      Napa::Authentication.password_header.should eq('Password' => 'foo')
    end

    it 'raises when the HEADER_PASSWORD env var is not defined' do
      ENV['HEADER_PASSWORD'] = nil
      expect{Napa::Authentication.password_header}.to raise_error
    end
  end
end