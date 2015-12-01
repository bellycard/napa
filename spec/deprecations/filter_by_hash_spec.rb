require 'spec_helper'

describe 'Napa::FilterByHash Deprecation' do
  it 'raises a deprecation warning when mixed in to a class' do
    expect(ActiveSupport::Deprecation).to receive(:warn)
    class FooModel; include Napa::FilterByHash; end
    ActiveSupport::Deprecation.silenced = false
  end
end
