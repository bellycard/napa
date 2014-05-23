require 'active_record'
require 'spec_helper'
require 'napa/active_record_extensions/stats.rb'

# Delete any prevous instantiations of the emitter and set valid statsd env vars
Napa::Stats.emitter = nil
ENV['STATSD_HOST'] = 'localhost'
ENV['STATSD_PORT'] = '8125'

describe Napa::ActiveRecordStats do
  before(:each) do
    Foo.delete_all
    @x = Foo.create(word: 'bar')
  end

  it 'should send a query_time for an insert' do
    Napa::Stats.emitter.should_receive(:timing).with(
      "#{Napa::Identity.name}.unknown.sql.foos.insert.query_time",
      an_instance_of(Float)
    )
    Foo.create(word: 'baz')
  end

  it 'should send a query_time for a select' do
    Napa::Stats.emitter.should_receive(:timing).with(
      "#{Napa::Identity.name}.unknown.sql.foos.select.query_time",
      an_instance_of(Float)
    )
    Foo.all.first
  end

  it 'should send a query_time for a delete' do
    Napa::Stats.emitter.should_receive(:timing).with(
      "#{Napa::Identity.name}.unknown.sql.foos.delete.query_time",
      an_instance_of(Float)
    )
    @x.delete
  end

  it 'should send a query_time for an update' do
    Napa::Stats.emitter.should_receive(:timing).with(
      "#{Napa::Identity.name}.unknown.sql.foos.update.query_time",
      an_instance_of(Float)
    )
    @x.word = 'baz'
    @x.save
  end
end
