master
===
* [Support Roar > 1.0](https://github.com/bellycard/napa/pull/242)
* [Move to CircleCI](https://github.com/bellycard/napa/pull/241)
* [Fix for Logging bug in :basic format](https://github.com/bellycard/napa/pull/222)
* [Remove deployment features, docker files, version rake task, and remove git and octokit dependencies](https://github.com/bellycard/napa/pull/254)

0.5.1
===
* [Heroku Customizations](https://github.com/bellycard/napa/pull/214)
* [Better Logger](https://github.com/bellycard/napa/pull/213)

0.5.0
===
* [Support for Rails style Model Generation](https://github.com/bellycard/napa/pull/207)
* [Resolves issue #205 by adding hashie-forbidden_attributes gem to generated Gemfile](https://github.com/bellycard/napa/pull/206)
* [use RAILS_ENV if RACK_ENV not found](https://github.com/bellycard/napa/pull/200)
* [Support for creating and dropping databases on non-standard ports](https://github.com/bellycard/napa/pull/166)
* Added an rspec response helper `expect_error_code` for easier testing of API methods which are supposed to send back a JSON representation of an error

0.4.3
===
* [Allow Napa::Authentication to receive multiple and accept multiple passwords](https://github.com/bellycard/napa/pull/190)
* [rename to silence_thor](https://github.com/bellycard/napa/pull/189)
* [Hey! Spec suite! Leave them streams alone!](https://github.com/bellycard/napa/pull/175)
* [Refactoring CLI](https://github.com/bellycard/napa/pull/186)

0.4.2
===
* [Explicitly require `filter_parameters.rb` instead of relying on `action_dispatch` autoload](https://github.com/bellycard/napa/pull/181)
* [Default rake task runs specs](https://github.com/bellycard/napa/pull/176)
* [Set Napa.env to the environment arg we pass in the console](https://github.com/bellycard/napa/pull/179)
* [Add thor command to start shotgun server](https://github.com/bellycard/napa/pull/177)
* [Lock honeybadger and roar in the meantime](https://github.com/bellycard/napa/pull/185)

0.4.1
===
* Added a reasons object to error responses to represent active record validation errors for individual attributes
* Added ability to filter sensitive data from logs.

0.4.0
===
* Added `Napa.cache` to wrap `ActiveSupport::Cache`
* Added README generator
* Update the HoneyBadger scaffolding
* Fixed a bug with Napa::StatsDTimer where time was being reported in seconds, not milliseconds
* Removed additional StatsD counter metric for request stats middleware
* Added new deploy CLI with `force` and `revision` options `napa deploy production`
* Added deprecation warnings
* Added initialization hook to run code when a Napa service boots
* Added Migration generators from Rails
* Added rake db:seed functionality
* Added some convenience methods to spec_helper

0.3.0
===
* Added `rake db:rollback` to rollback migrations just like Rails
* Fixed bug in migration generator causing constant not defined errors
* Fixed CORS config in scaffold generator
* Fixed logging bug in grape_extenders
* Set UTF-8 encoding in generated database.yml
* Removed unneeded gem dependencies (shotgun and unicorn)
* Fixed spec_helper that gets generated to ignore spec files and gems (on CI servers)
* Added spec response helpers `parsed_response`, `response_code` and `response_body` to make tests easier to DRY up
* Removed #filter and `include Napa::FilterByHash` from generated code.
* Fix when using IRB and napa console
* Added IncludeNil module for Representable/Roar output
* Template updates to include spec files for APIs
* Removing FilterByHash in the API template
* Fix when ErrorFormatter is passed a non-hash
* Added more descriptive messages on git based deploy errors
* Added RequestStats and DatabaseStats middlewares to report data to StatsD
* All String logs are now wrapped in a hash before being written to the log file

0.2.1
===
* Updated Napa console. It now takes an optional environment parameter, i.e. `napa console production`.
* Added `c` alias for Napa console, i.e. `napa c` or `napa c production`
* Fixed a bug causing `rake db:schema:load` to fail
* Fixed a bug affecting `rake db:create` and `rake db:drop` using Postgres
* Fixed a bug Napa::GrapeHelpers to bypass the representer when given an array

0.2.0
===
* The console is now run with `napa console`, added support for racksh
* Scaffold generator now supports the `--database (-d)` flag
* Scaffold generator now supports Mysql or Postgres with ActiveRecord
* Scaffold generator now uses Roar instead of Grape Entity
* Fixed a bug in `rake routes`
* Fixed a bug in `rake db:reset`
* Added StatsD instrumentation (experimental)
* Added a CHANGELOG
