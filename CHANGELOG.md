master
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
