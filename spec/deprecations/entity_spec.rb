require 'spec_helper'
require 'active_support'

describe 'Napa::Entity Deprecation' do
  it 'raises a deprecation warning when a class inherits' do
    expect(ActiveSupport::Deprecation).to receive(:warn)
    class FooEntity < Napa::Entity; end
  end
end
