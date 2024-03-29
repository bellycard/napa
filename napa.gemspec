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

  gem.add_dependency 'rake', '~> 10.3.0'
  gem.add_dependency 'logging', '~> 2.0.0'
  gem.add_dependency 'dotenv'
  gem.add_dependency 'octokit', '~> 3.5.0'
  gem.add_dependency 'thor', '~> 0.19.0'
  gem.add_dependency 'virtus', '~> 1.0.0'
  gem.add_dependency 'grape', '~> 0.10.0'
  gem.add_dependency 'grape-swagger'
  gem.add_dependency 'roar', ['>= 0.12.0', '< 2.0']
  gem.add_dependency 'statsd-ruby', '~> 1.2.0'
  gem.add_dependency 'racksh', '~> 1.0.0'
  gem.add_dependency 'git', '~> 1.2.0'
  gem.add_dependency 'actionpack', '~> 5.0'
  gem.add_dependency 'indefinite_article', '~> 0.2.0'

  gem.add_development_dependency 'rspec', '~> 3.1.0'
  gem.add_development_dependency 'pry', '~> 0.10.0'
  gem.add_development_dependency 'rubocop', '~> 0.25.0'
  gem.add_development_dependency 'activerecord', '~> 3.2.0'
  gem.add_development_dependency 'sqlite3', '~> 1.3.0'
  gem.add_development_dependency 'acts_as_fu', '~> 0'
  gem.add_development_dependency 'codeclimate-test-reporter'
end
