# -*- encoding: utf-8 -*-
require File.expand_path('../lib/napa/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Darby Frey"]
  gem.email         = ["darby@bellycard.com"]
  gem.description   = %q{A simple framework for building APIs with Grape}
  gem.summary       = %q{A simple framework for building APIs with Grape}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   << 'napa'
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "napa"
  gem.require_paths = ["lib"]
  gem.version       = Napa::VERSION


  gem.add_dependency 'rake'
  gem.add_dependency 'logging'
  gem.add_dependency 'dotenv'
  gem.add_dependency 'octokit', '~> 1.25'
  gem.add_dependency 'virtus'
  gem.add_dependency 'grape'
  gem.add_dependency 'grape-swagger'
  gem.add_dependency 'grape-entity'
  gem.add_dependency 'unicorn'

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "pry"
  gem.add_development_dependency "git"
  gem.add_development_dependency "rubocop"
end
