module Napa
  class Authentication
    def self.password_header
      password_hash = {}
      password_hash['Password'] = ENV['HEADER_PASSWORD'] if ENV['HEADER_PASSWORD']
      password_hash['Passwords'] = ENV['SENT_HEADER_PASSWORDS'] if ENV['SENT_HEADER_PASSWORDS']
      fail 'header_password_not_configured' if password_hash.keys.blank?
      password_hash
    end
  end
end
