module Napa
  class Deprecations
    REQUIRED_PATTERNS = [
      /require 'bundler\/setup'/,
      /Bundler.setup\(:default\)/,
      /require 'napa\/setup'/,
      /Bundler.require\(:default, Napa.env.to_sym\)/,
      /require 'napa'/,
      /Napa.load_environment/,
      /Dir['.\/config\/initializers\/**\/*.rb'].map { |file| require file }/,
      /Dir['.\/config\/middleware\/**\/*.rb'].map { |file| require file }/,
      /relative_load_paths/,
      /ActiveSupport::Dependencies.autoload_paths \+\= relative_load_paths/
    ]

    EXPIRED_PATTERNS = [
      /require 'dotenv'/,
      "RACK_ENV = ENV['RACK_ENV']",
      "if RACK_ENV == 'test'",
      /Dotenv.load\(".env.test"\)/,
      /Dotenv.load\(Napa.env.test\? \? '.env.test' : '.env'\)/,
      /Bundler.require :default, RACK_ENV/,
      /require 'will_paginate'/,
      /require 'will_paginate\/active_record'/
    ]

    def self.napa_setup_check
      required_patterns_regex = Regexp.union(REQUIRED_PATTERNS)
      expired_patterns_regex = Regexp.union(EXPIRED_PATTERNS)

      if File.exists?('./app.rb')
        if File.readlines('./app.rb').grep(expired_patterns_regex).any? || (File.readlines('./app.rb').grep(required_patterns_regex).count < REQUIRED_PATTERNS.count)
          ActiveSupport::Deprecation.warn 'app.rb is out of date, please update your configuration', caller
        end
      end
    end
  end
end
