require 'spec_helper'
require 'napa/logger/logger'
require 'napa/logger/configuration'
require 'napa/logger/output/file'

describe Napa::Logger::Output::File do
  before do
    allow(Napa::Logger).to receive_message_chain(:logger, :add_appenders)
    @logfile = '/tmp/test.log'
  end

  after do
    FileUtils.rm(@logfile) if File.exist?(@logfile)
  end

  describe '#options' do
    it 'adds no layout option for the basic format' do
      allow_any_instance_of(Napa::Logger::Configuration).to receive(:format).and_return(:basic)
      file = Napa::Logger::Output::File.new(@logfile)
      expect(file.options[:layout]).to be_nil
    end

    it 'adds the json layout for the json format' do
      allow_any_instance_of(Napa::Logger::Configuration).to receive(:format).and_return(:json)
      file = Napa::Logger::Output::File.new(@logfile)
      expect(file.options[:layout].instance_variable_get(:@style)).to eq(:json)
    end

    it 'adds the yaml layout for the yaml format' do
      allow_any_instance_of(Napa::Logger::Configuration).to receive(:format).and_return(:yaml)
      file = Napa::Logger::Output::File.new(@logfile)
      expect(file.options[:layout].instance_variable_get(:@style)).to eq(:yaml)
    end
  end

  describe '#enable?' do
    it 'returns true when included in the config' do
      allow_any_instance_of(Napa::Logger::Configuration).to receive(:output).and_return([:file])
      file = Napa::Logger::Output::File.new(@logfile)
      expect(file.enable?).to be true
    end

    it 'returns false when not included in the config' do
      allow_any_instance_of(Napa::Logger::Configuration).to receive(:output).and_return([:foo])
      file = Napa::Logger::Output::File.new(@logfile)
      expect(file.enable?).to be false
    end
  end

end
