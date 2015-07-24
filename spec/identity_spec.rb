require 'spec_helper'
require 'napa/identity'

describe Napa::Identity do
  context '#name' do
    it "returns 'api-service' if no ENV['SERVICE_NAME'] is set" do
      ENV['SERVICE_NAME'] = nil
      expect(Napa::Identity.name).to eq('api-service')
    end

    it "returns the ENV['SERVICE_NAME'] when specified" do
      ENV['SERVICE_NAME'] = nil
      ENV['SERVICE_NAME'] = 'my-service'
      expect(Napa::Identity.name).to eq('my-service')
    end
  end

  context '#hostname' do
    it 'returns the value of the hostname system call and doesn\'t make a second system call' do
      expect(Napa::Identity).to receive(:`).with('hostname').and_return('system-hostname')
      expect(Napa::Identity.hostname).to eq('system-hostname')

      expect(Napa::Identity).to_not receive(:`).with('hostname')
      expect(Napa::Identity.hostname).to eq('system-hostname')
    end
  end

  context '#revision' do
    before do
      Napa::Identity.instance_variable_set :@revision, nil
    end

    it 'returns the value of the \'git rev-parse HEAD\' system call and doesn\'t make a second system call' do
      expect(Napa::Identity).to receive(:`).with('git rev-parse HEAD').and_return('12345')
      expect(Napa::Identity.revision).to eq('12345')

      expect(Napa::Identity).to_not receive(:`).with('git rev-parse HEAD')
      expect(Napa::Identity.revision).to eq('12345')
    end

    it 'returns the value of .gitsha if in the Heroku environment if file exists' do
      allow(ENV).to receive(:[]).with("DYNO").and_return("foo")
      allow(File).to receive(:exist?).with('.gitsha').and_return(true)
      allow(File).to receive(:read).with('.gitsha').and_return('98765')
      expect(Napa::Identity.revision).to eq('98765')
    end

    it 'returns the empty string in the Heroku environment when no .gitsha file' do
      allow(ENV).to receive(:[]).with("DYNO").and_return("foo")
      expect(Napa::Identity.revision).to eq('')
    end
  end

  context '#pid' do
    it 'returns the process ID value' do
      allow(Process).to receive(:pid).and_return(112233)
      expect(Napa::Identity.pid).to eq(112233)
    end
  end

  context '#platform_revision' do
    it 'returns the current version of the platform gem' do
      expect(Napa::Identity.platform_revision).to eq(Napa::VERSION)
    end
  end
end
