require 'spec_helper'
require 'napa/version'

describe Napa::Version do
  context "#major_bump" do
    it "should set the major revision value, and the rest should be 0" do
      stub_const("Napa::VERSION", "1.2.3")
      Napa::Version.next_major.should == "2.0.0"
    end

    it "should set the major revision value, and the rest should be 0" do
      stub_const("Napa::VERSION", "5.0.0")
      Napa::Version.next_major.should == "6.0.0"
    end
  end

  context "#minor_bump" do
    it "should set the minor revision value, leaving the major value unchanged and the patch value to 0" do
      stub_const("Napa::VERSION", "1.2.3")
      Napa::Version.next_minor.should == "1.3.0"
    end

    it "should set the minor revision value, leaving the major value unchanged and the patch value to 0" do
      stub_const("Napa::VERSION", "0.5.0")
      Napa::Version.next_minor.should == "0.6.0"
    end
  end

  context "patch_bump" do
    it "should set the patch revision value, leaving the major and minor values unchanged" do
      stub_const("Napa::VERSION", "1.2.3")
      Napa::Version.next_patch.should == "1.2.4"
    end

    it "should set the patch revision value, leaving the major and minor values unchanged" do
      stub_const("Napa::VERSION", "5.5.5")
      Napa::Version.next_patch.should == "5.5.6"
    end
  end
end
