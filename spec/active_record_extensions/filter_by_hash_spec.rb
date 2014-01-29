require 'active_record'
require 'spec_helper'
require 'napa/active_record_extensions/filter_by_hash'

class Foo < ActiveRecord::Base
  include Napa::FilterByHash
end

describe Napa::FilterByHash do
  context 'when a hash is provided' do
    it 'returns an AR relation' do
      expect(Foo.filter).to be_a(ActiveRecord::Relation)
    end
  end

  context 'when nothing is provided' do
    it 'returns an AR relation' do
      expect(Foo.filter).to be_a(ActiveRecord::Relation)
    end
  end
end
