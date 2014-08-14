require 'spec_helper'
require 'napa/version'

describe Napa::Version do
  context '#major_bump' do
    it 'should set the major revision value, and the rest should be 0' do
      stub_const('Napa::VERSION', '1.2.3')
      expect(Napa::Version.next_major).to eq('2.0.0')
    end

    it 'should set the major revision value, and the rest should be 0' do
      stub_const('Napa::VERSION', '5.0.0')
      expect(Napa::Version.next_major).to eq('6.0.0')
    end
  end

  context '#minor_bump' do
    it 'should set the minor revision value, leaving the major value unchanged and the patch value to 0' do
      stub_const('Napa::VERSION', '1.2.3')
      expect(Napa::Version.next_minor).to eq('1.3.0')
    end

    it 'should set the minor revision value, leaving the major value unchanged and the patch value to 0' do
      stub_const('Napa::VERSION', '0.5.0')
      expect(Napa::Version.next_minor).to eq('0.6.0')
    end
  end

  context 'patch_bump' do
    it 'should set the patch revision value, leaving the major and minor values unchanged' do
      stub_const('Napa::VERSION', '1.2.3')
      expect(Napa::Version.next_patch).to eq('1.2.4')
    end

    it 'should set the patch revision value, leaving the major and minor values unchanged' do
      stub_const('Napa::VERSION', '5.5.5')
      expect(Napa::Version.next_patch).to eq('5.5.6')
    end
  end
end
