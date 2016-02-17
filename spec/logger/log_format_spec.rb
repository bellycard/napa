require 'spec_helper'

describe 'Logging output format' do
  capture_log_messages

  it "Generic INFO log format" do
    log_message      = "my cool message"
    expected_message = "INFO  #{Napa::Logger.logger.name} : #{log_message}"

    Napa::Logger.logger.info(log_message)

    expect(@log_output.readline.strip).to eql(expected_message)
  end

  it "logs rack request" do
    remote_addr = "127.0.0.1"
    query       = "message=hello"
    path        = "/hello/outside"
    params      = { 'message' => 'hello' }

    env = {
      "QUERY_STRING"   => query,
      "REQUEST_METHOD" => "GET",
      "REQUEST_PATH"   => path,
      "REQUEST_URI"    => path,
      "PATH_INFO"      => path,
      "REMOTE_ADDR"    => remote_addr,
      "rack.input"     => StringIO.new
    }

    mock_app = Proc.new {}
    Napa::Middleware::Logger.new(mock_app).call(env)

    logger_name = Napa::Logger.logger.name

    # using the output we are testing is a hack
    # but it let's us us the hash object for the other parts
    log_output = @log_output.readline.strip

    pid        = log_output.match(/:pid=>(\d*)/)[1]
    host       = log_output.gsub('"','').match(/:host=>(\S*),/)[1]
    revision   = log_output.gsub('"','').match(/:revision=>(\S*),/)[1]

    log_output_hash = { request: {
        method:    "GET",
        path:      path,
        query:     query,
        host:      host,
        pid:       pid.to_i,
        revision:  revision,
        params:    params,
        remote_ip: remote_addr
      }
    }

    expected_log_message = "INFO  #{logger_name} : <Hash> #{log_output_hash.to_s}"

    expect(log_output).to eq(expected_log_message)
  end
end
