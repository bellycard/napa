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
      expect(Napa::LogTransaction.id).to eq(id)
    end

    it 'sets and returns a new id if the transaction id hasn\'t been set' do
      expect(Napa::LogTransaction.id).to_not be_nil
    end

    it 'allows the id to be overridden by a setter' do
      expect(Napa::LogTransaction.id).to_not be_nil
      Napa::LogTransaction.id = 'foo'
      expect(Napa::LogTransaction.id).to eq('foo')
    end
  end

  context '#clear' do
    it 'sets the id to nil' do
      expect(Napa::LogTransaction.id).to_not be_nil
      Napa::LogTransaction.clear
      expect(Thread.current[:napa_tid]).to be_nil
    end
  end
end
