require 'spec_helper'
require 'napa/logger/configuration'

describe Napa::Logger::Configuration do
  describe '#format' do
    it 'returns json by default' do
      config = Napa::Logger::Configuration.new
      expect(config.format).to eq(:json)
    end

    it 'returns an override is supplied in @options' do
      config = Napa::Logger::Configuration.new(format: :yaml)
      expect(config.format).to eq(:yaml)
    end

    it 'returns basic in the development environment' do
      allow(Napa).to receive_message_chain(:env, :development?).and_return(true)
      config = Napa::Logger::Configuration.new
      expect(config.format).to eq(:basic)
    end

    it 'returns basic if in the Heroku environment' do
      allow(ENV).to receive(:[]).with("DYNO").and_return("foo")
      config = Napa::Logger::Configuration.new
      expect(config.format).to eq(:basic)
    end
  end

  describe '#output' do
    it 'returns :stdout and :file by default' do
      config = Napa::Logger::Configuration.new
      expect(config.output).to eq([:stdout, :file])
    end

    it 'returns an override is supplied in @options' do
      config = Napa::Logger::Configuration.new(output: :file)
      expect(config.output).to eq([:file])
    end

    it 'returns only :stdout if in the Heroku environment' do
      allow(ENV).to receive(:[]).with("DYNO").and_return("foo")
      config = Napa::Logger::Configuration.new
      expect(config.output).to eq([:stdout])
    end
  end

  describe '#request_level' do
    it 'returns :info by default' do
      config = Napa::Logger::Configuration.new
      expect(config.request_level).to eq(:info)
    end

    it 'returns an override is supplied in @options' do
      config = Napa::Logger::Configuration.new(request_level: :debug)
      expect(config.request_level).to eq(:debug)
    end
  end

  describe '#response_level' do
    it 'returns :debug by default' do
      config = Napa::Logger::Configuration.new
      expect(config.response_level).to eq(:debug)
    end

    it 'returns an override is supplied in @options' do
      config = Napa::Logger::Configuration.new(response_level: :warning)
      expect(config.response_level).to eq(:warning)
    end
  end
end
