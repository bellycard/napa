require 'spec_helper'
require 'napa/grape_extensions/error_formatter'

describe Napa::GrapeHelpers do
    describe 'represent' do
        it 'should not rely on to_a if the data is enumerable with :map' do
            class Foo
                def to_a
                    puts "Called to_a"
                end
                def map
                    puts "Called map"
                end
            end

            class FooRepresenter < Napa::Representer
            end    

            class DummyClass
                include Napa::GrapeHelpers
            end        

            foo = double("Foo")
            expect(foo).not_to receive(:to_a)
            expect(foo).to receive(:map) { ["foo", "bar"] }

            DummyClass.new.represent(foo, with: FooRepresenter)
        end
    end
end