require 'spec_helper'
require 'napa/logger/log_transaction'

describe Napa::LogTransaction do
  before(:each) do
    Napa::LogTransaction.clear
  end

  context '#id' do
    it 'returns the current transaction id if it has been set' do
      id = SecureRandom.hex(10)
      Thread.current[:napa_tid] = id
      Napa::LogTransaction.id.should == id
    end

    it 'sets and returns a new id if the transaction id hasn\'t been set' do
      Napa::LogTransaction.id.should_not be_nil
    end

    it 'allows the id to be overridden by a setter' do
      Napa::LogTransaction.id.should_not be_nil
      Napa::LogTransaction.id = 'foo'
      Napa::LogTransaction.id.should == 'foo'
    end
  end

  context '#clear' do
    it 'sets the id to nil' do
      Napa::LogTransaction.id.should_not be_nil
      Napa::LogTransaction.clear
      Thread.current[:napa_tid].should be_nil
    end
  end
end
