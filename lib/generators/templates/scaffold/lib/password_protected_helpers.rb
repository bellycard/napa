module PasswordProtectedHelpers
  if ENV['HEADER_PASSWORDS']
    PW_ARRAY = ENV['HEADER_PASSWORDS'].split(',').collect{|pw| pw.strip}.freeze 
  else
    PW_ARRAY = [nil].freeze
  end

  def authenticate headers
    error!({:error => {
      :code => 'bad_password', 
      :message => 'bad password'}}
    ) unless PW_ARRAY.include? headers['Password']
  end

  # extend all endpoints to include this
  Grape::Endpoint.send :include, self
end
