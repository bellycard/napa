require 'spec_helper'
require 'napa/logger/parseable'

describe Logging::Layouts::Parseable do
  context '#format_obj' do
    it 'formats text as an object' do
      p = Logging::Layouts::Parseable.new
      expect(p.format_obj('foobar')).to eq({ text: 'foobar' })
    end

    it 'does not reformat objects' do
      p = Logging::Layouts::Parseable.new
      expect(p.format_obj({ foo: :bar })).to eq({ foo: :bar })
    end
  end
end
