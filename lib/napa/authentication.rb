module Napa
  class Authentication
    def self.password_header
      passwords = ENV['HEADER_PASSWORD'] || ENV['SENT_HEADER_PASSWORDS']
      raise 'header_password_not_configured' unless passwords
      { 'Password' => passwords }
    end
  end
end