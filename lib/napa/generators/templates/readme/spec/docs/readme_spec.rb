require 'spec_helper'

describe 'README' do
  it 'has been filled out' do
    readme = File.read('README.md')

    expect(readme).not_to match(/:poop:/)
  end
end
