require 'spec_helper'
require 'napa/identity'

describe Napa::Identity do
  context "#name" do
    it "returns 'api-service' if no ENV['SERVICE_NAME'] is set" do
      ENV['SERVICE_NAME'] = nil
      Napa::Identity.name.should == 'api-service'
    end

    it "returns the ENV['SERVICE_NAME'] when specified" do
      ENV['SERVICE_NAME'] = nil
      ENV['SERVICE_NAME'] = 'my-service'
      Napa::Identity.name.should == 'my-service'
    end
  end

  context "#hostname" do
    it "returns the value of the hostname system call and doesn't make a second system call" do
      Napa::Identity.should_receive(:`).with("hostname").and_return("system-hostname")
      Napa::Identity.hostname.should == 'system-hostname'

      Napa::Identity.should_not_receive(:`).with("hostname")
      Napa::Identity.hostname.should == 'system-hostname'
    end
  end

  context "#revision" do
    it "returns the value of the 'git rev-parse HEAD' system call and doesn't make a second system call" do
      Napa::Identity.should_receive(:`).with("git rev-parse HEAD").and_return("12345")
      Napa::Identity.revision.should == '12345'

      Napa::Identity.should_not_receive(:`).with("git rev-parse HEAD")
      Napa::Identity.revision.should == '12345'
    end
  end

  context "#pid" do
    it "returns the process ID value" do
      Process.stub(:pid).and_return(112233)
      Napa::Identity.pid.should == 112233
    end
  end

  context "#platform_revision" do
    it "returns the current version of the platform gem" do
      Napa::Identity.platform_revision.should == Napa::VERSION
    end
  end
end