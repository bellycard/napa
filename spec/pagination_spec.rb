require 'spec_helper'
require 'napa/pagination'

describe Napa::Pagination do
  context '#to_h' do
    it 'returns all pagination attributes that the object responds to' do
      object = Hashie::Mash.new(
        current_page: 2,
        limit_value: 25,
        total_pages: 10,
        total_count: 248
      )

      data = Napa::Pagination.new(object)
      data.to_h[:page].should be(2)
      data.to_h[:per_page].should be(25)
      data.to_h[:total_pages].should be(10)
      data.to_h[:total_count].should be(248)
    end

    it 'skips an attribute if the object does not respond to it' do
      object = Hashie::Mash.new(
        current_page: 2,
        limit_value: 25
      )

      data = Napa::Pagination.new(object)
      data.to_h[:page].should be(2)
      data.to_h[:per_page].should be(25)
      data.to_h[:total_pages].should be_nil
      data.to_h[:total_count].should be_nil
    end
  end
end
