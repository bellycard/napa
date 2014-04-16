master
===
* Fixed a bug causing `rake db:schema:load` to fail
* Fixed a bug affecting `rake db:create` and `rake db:drop` using Postgres

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
