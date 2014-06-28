require 'spec_helper'
require 'napa/grape_extensions/include_nil'
require 'napa/grape_extensions/grape_helpers'
require 'pry'

describe Napa::Representable::IncludeNil do
  class FooRepresenter < Napa::Representer
    include Napa::Representable::IncludeNil
    property :foo
    property :bar
  end

  class DummyClass
    include Napa::GrapeHelpers
  end

  it 'includes nil keys in a represented hash' do
    input = OpenStruct.new(foo: 1, bar: nil)
    output = DummyClass.new.represent(input, with: FooRepresenter).to_h
    expect(output[:data]).to have_key('foo')
    expect(output[:data]).to have_key('bar')
  end
end
