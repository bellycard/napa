require 'spec_helper'
require 'napa/grape_extensions/grape_helpers'
require 'kaminari/grape'

class FooApi < Grape::API; end
class FooRepresenter < Napa::Representer; end

describe Napa::GrapeHelpers do
  before do
    @endpoint = Grape::Endpoint.new(nil, {path: '/test', method: :get})
  end

  context '#present_error' do
    it 'returns a Napa::JsonError response for the given error' do
      data = @endpoint.present_error(404, 'Record not found')

      data.class.should be(Napa::JsonError)
      data.to_h[:error][:code].should be(404)
      data.to_h[:error][:message].should eq('Record not found')
    end

    it 'returns an empty string if no message given' do
      data = @endpoint.present_error(404)

      data.class.should be(Napa::JsonError)
      data.to_h[:error][:code].should be(404)
      data.to_h[:error][:message].should eq('')
    end
  end

  context '#paginate' do
    before do
      Foo.create(word: 'bar')
      Foo.create(word: 'baz')
    end

    after do
      Foo.destroy_all
    end

    it 'returns the collection if it is already paginated' do
      objects = Kaminari.paginate_array([Foo.new, Foo.new, Foo.new]).page(1)
      output = @endpoint.paginate(objects)

      output.class.should eq(objects.class)
    end

    it 'returns a paginated collection if given an array' do
      output = @endpoint.paginate(Foo.all.page(1))

      output.class.should be(Foo::ActiveRecord_Relation)
      output.total_pages.should be(1)
      output.total_count.should be(2)
    end

    it 'returns a paginated collection if given an ActiveRecord_Relation' do
      output = @endpoint.paginate(Foo.all)

      output.total_count.should be(2)
      output.total_pages.should be(1)
    end

    it 'overrides the page and per_page defaults if supplied as params' do
      @endpoint.stub_chain(:params, :page).and_return(2)
      @endpoint.stub_chain(:params, :per_page).and_return(1)

      output = @endpoint.paginate(Foo.all)

      output.current_page.should be(2)
      output.total_count.should be(2)
      output.total_pages.should be(2)
    end
  end

  context '#represent' do
    it 'raises an exception if no representer is given' do
      object = Foo.new
      expect{ @endpoint.represent(object) }.to raise_error
    end

    it 'returns the object nested in the data key when given a single object' do
      object = Foo.new
      output = @endpoint.represent(object, with: FooRepresenter)

      output.has_key?(:data).should be_true
      output[:data]['object_type'].should eq('foo')
    end

    it 'returns a collection of objects nested in the data key' do
      objects = [Foo.new, Foo.new, Foo.new]
      output = @endpoint.represent(objects, with: FooRepresenter)

      output.has_key?(:data).should be_true
      output[:data].class.should be(Array)
      output[:data].first['object_type'].should eq('foo')
    end

    it 'returns a collection with pagination attributes if the collection is paginated' do
      objects = Kaminari.paginate_array([Foo.new, Foo.new, Foo.new]).page(1)
      output = @endpoint.represent(objects, with: FooRepresenter)

      output.has_key?(:data).should be_true
      output.has_key?(:pagination).should be_true
      output[:pagination][:page].should eq(1)
      output[:pagination][:per_page].should eq(25)
      output[:pagination][:total_pages].should eq(1)
      output[:pagination][:total_count].should eq(3)
    end
  end
end
