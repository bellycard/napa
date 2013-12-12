module Napa
  class Authentication
    def self.password_header
      raise 'header_password_not_configured' unless ENV['HEADER_PASSWORD']
      { 'Password' => ENV['HEADER_PASSWORD'] }
    end
  end
end