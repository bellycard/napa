ENV['RACK_ENV'] = 'test'

require 'napa/setup'
require 'acts_as_fu'

require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

Napa.skip_initialization = true

require 'napa'
require 'napa/rspec_extensions/response_helpers'

module NapaSpecClassHelpers
  def silence_thor
    before do
      allow_any_instance_of(Thor::Shell::Basic)
        .to receive(:stdout).and_return(object_spy $stdout)
      allow_any_instance_of(Thor::Shell::Basic)
        .to receive(:stderr).and_return(object_spy $stderr)
    end
  end
end

ActiveRecord::Schema.verbose = false

# from https://gist.github.com/adamstegman/926858
RSpec.configure do |config|
  config.include Napa::RspecExtensions::ResponseHelpers
  config.extend NapaSpecClassHelpers
  config.include ActsAsFu

  config.before(:each) do
    allow(Napa::Logger).to receive_message_chain('logger.info').with(:napa_deprecation_warning)
  end
end
