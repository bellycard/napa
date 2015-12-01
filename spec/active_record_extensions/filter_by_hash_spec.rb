require 'active_record'
require 'spec_helper'
require 'napa/active_record_extensions/filter_by_hash'

describe Napa::FilterByHash do
  before do
    expect(ActiveSupport::Deprecation).to receive(:warn)
    class Foo < ActiveRecord::Base; include Napa::FilterByHash; end
  end

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
