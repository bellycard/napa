require 'spec_helper'
require 'napa/logger/logger'
require 'napa/logger/configuration'
require 'napa/logger/output/stdout'

describe Napa::Logger::Output::Stdout do
  before do
    allow(Napa::Logger).to receive_message_chain(:logger, :add_appenders)
  end

  describe '#options' do
    it 'adds no layout option for the basic format' do
      allow_any_instance_of(Napa::Logger::Configuration).to receive(:format).and_return(:basic)
      stdout = Napa::Logger::Output::Stdout.new
      expect(stdout.options[:layout]).to be_nil
    end

    it 'adds the json layout for the json format' do
      allow_any_instance_of(Napa::Logger::Configuration).to receive(:format).and_return(:json)
      stdout = Napa::Logger::Output::Stdout.new
      expect(stdout.options[:layout].instance_variable_get(:@style)).to eq(:json)
    end

    it 'adds the yaml layout for the yaml format' do
      allow_any_instance_of(Napa::Logger::Configuration).to receive(:format).and_return(:yaml)
      stdout = Napa::Logger::Output::Stdout.new
      expect(stdout.options[:layout].instance_variable_get(:@style)).to eq(:yaml)
    end
  end

  describe '#enable?' do
    it 'returns true when included in the config' do
      allow_any_instance_of(Napa::Logger::Configuration).to receive(:output).and_return([:stdout])
      stdout = Napa::Logger::Output::Stdout.new
      expect(stdout.enable?).to be true
    end

    it 'returns false when not included in the config' do
      allow_any_instance_of(Napa::Logger::Configuration).to receive(:output).and_return([:foo])
      stdout = Napa::Logger::Output::Stdout.new
      expect(stdout.enable?).to be false
    end
  end

end
