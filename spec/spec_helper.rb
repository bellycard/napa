ENV['RACK_ENV'] = 'test'

require 'napa/setup'
require 'acts_as_fu'

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

Napa.skip_initialization = true

require 'napa'
require 'napa/rspec_extensions/response_helpers'

# from https://gist.github.com/adamstegman/926858
RSpec.configure do |config|
  config.include Napa::RspecExtensions::ResponseHelpers

  config.before(:all) { silence_output }
  config.after(:all) { enable_output }

  config.include ActsAsFu

  config.before(:each) do
    allow(Napa).to receive(:initialize)
    allow(Napa::Logger).to receive_message_chain('logger.info').with(:napa_deprecation_warning)
  end
end

# Redirects stderr and stdout to /dev/null.
def silence_output
  @orig_stderr = $stderr
  @orig_stdout = $stdout

  # redirect stderr and stdout to /dev/null
  $stderr = File.new('/dev/null', 'w')
  $stdout = File.new('/dev/null', 'w')
end

# Replace stdout and stderr so anything else is output correctly.
def enable_output
  $stderr = @orig_stderr
  $stdout = @orig_stdout
  @orig_stderr = nil
  @orig_stdout = nil
end
