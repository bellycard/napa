require 'napa'

ENV['RACK_ENV'] = 'test'

# from https://gist.github.com/adamstegman/926858
RSpec.configure do |config|
  config.before(:all) { silence_output }
  config.after(:all) { enable_output }
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
