# -*- encoding: utf-8 -*-
require File.expand_path('../lib/napa/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Darby Frey']
  gem.email         = ['darby@bellycard.com']
  gem.description   = 'A simple framework for building APIs with Grape'
  gem.summary       = 'A rack-based framework wrapping around the Grape REST-like framework for Ruby.'
  gem.homepage      = 'https://tech.bellycard.com'
  gem.licenses      = ['MIT']

  gem.files         = Dir['**/*'].keep_if { |file| File.file?(file) }
  gem.executables   << 'napa'
  gem.test_files    = Dir['spec/**/*']
  gem.name          = 'napa'
  gem.require_paths = ['lib']
  gem.version       = Napa::VERSION
  gem.required_ruby_version = '>= 2.0'

  gem.add_dependency 'rake'
  gem.add_dependency 'logging'
  gem.add_dependency 'dotenv'
  gem.add_dependency 'octokit'
  gem.add_dependency 'thor'
  gem.add_dependency 'virtus'
  gem.add_dependency 'grape'
  gem.add_dependency 'grape-swagger'
  gem.add_dependency 'roar', '~> 0.12.0'
  gem.add_dependency 'statsd-ruby'
  gem.add_dependency 'racksh'
  gem.add_dependency 'git'
  gem.add_dependency 'actionpack'
  gem.add_dependency 'indefinite_article'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'activerecord'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'acts_as_fu'
  gem.add_development_dependency 'codeclimate-test-reporter'
end
