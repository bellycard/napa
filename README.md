[![Build Status](https://travis-ci.org/bellycard/napa.png?branch=master)](https://travis-ci.org/bellycard/napa)
[![Dependency Status](https://gemnasium.com/bellycard/napa.png)](https://gemnasium.com/bellycard/napa)
[![Code Climate](https://codeclimate.com/github/bellycard/napa/badges/gpa.svg)](https://codeclimate.com/github/bellycard/napa)
[![Test Coverage](https://codeclimate.com/github/bellycard/napa/badges/coverage.svg)](https://codeclimate.com/github/bellycard/napa)

# Napa

Napa is a simple framework for building Rack based APIs using Grape, Roar and ActiveRecord. It's designed to make it easy to quickly create and deploy new API services by providing **generators**, **middlewares** and a **console** similar to what you would expect from a Rails app.

## Installation

Napa is available as a gem, to install it run:

```
gem install napa
```

Or, if you're using Bundler, add it to your Gemfile:

```
gem 'napa'
```

And run:

```
$ bundle install
```

## Getting Started

See the [Quickstart Guide](https://github.com/bellycard/napa/blob/master/docs/quickstart.md) for an intro to creating a simple service with Napa.

## Usage

Run `napa` terminal prompt to see available features:

```
Commands:
  napa console [environment]                                                            # Start the Napa console
  napa generate api <api_name>                                                          # Create a Grape API, Model and Representer
  napa generate migration <migration_name> [field[:type][:index] field[:type][:index]]  # Create a Database Migration
  napa generate readme                                                                  # Create a formatted README
  napa deploy <environment>                                                             # Deploy to <environment> by setting a git tag
  napa help [COMMAND]                                                                   # Describe available commands or one specific command
  napa new <app_name> [app_path]                                                        # Create a scaffold for a new Napa service
  napa version                                                                          # Shows the Napa version number
```


### Console
Similar to the Rails console, load an IRB session with your applications environment by running:

```
napa console
```

### Deploy
Napa provides a CLI for deploying to a given environment by setting a git tag. This is useful for chef-based deploys where deploys are trigged when a git SHA changes.

```sh
napa deploy production
Are you sure you want to deploy this service? Y
#=> <git SHA> tagged as production by danielmackey at October 09, 2014 14:41
```

If you want to skip the 'Are you sure?' prompt, pass the `--confirm` flag to set the tag automatically
```sh
napa deploy production --confirm
#=> <git SHA> tagged as production by danielmackey at October 09, 2014 14:41
```

### Rake Tasks

`rake -T` will give you a list of all available rake tasks:

```
rake db:create          # Create the database
rake db:drop            # Delete the database
rake db:migrate         # Migrate the database through scripts in db/migrate
rake db:reset           # Create the test database
rake db:schema:dump     # Create a db/schema.rb file that can be portably used against any DB supported by AR
rake db:schema:load     # Load a schema.rb file into the database
rake db:seed            # Load the seed data from db/seeds.rb
rake git:set_tag[tag]   # Set tag, which triggers deploy
rake git:verify         # Verify git repository is in a good state for deployment
rake routes             # display all routes for Grape
```

## Middlewares
Napa includes a number of Rack middlewares that can be enabled to add functionality to your project.

### Authentication
The Authentication middleware will add a simple header based authentication layer to all requests. This is just looking for a header of `'Password' = 'Your Password'`. The passwords are defined in the `.env` file. You can allow multiple passwords by supplying a comma separated list. For example:

`HEADER_PASSWORDS='password1,password2'`

If your application doesn't require authentication, you can simply remove the middleware.

### Health Check
The Health Check middleware will add an endpoint at `/health` that will return some data about your app. This was created to allow monitoring tools a standardized way to monitor multiple services. This endpoint will return a response similar to this:

```
{
    "name": "service-name",
    "hostname": "host-name",
    "revision": "current-git-sha-of-app",
    "pid": 1234,
    "parent_pid": 1233,
    "napa_revision": "running-version-of-napa"
}
```

### Logger
The *Logger* module is used to create a common log format across applications. The Logger is enable via a rack middleware by adding the line below to your `config.ru` file:

```ruby
use Napa::Middleware::Logger
```

You can also enable the logger for ActiveRecord by adding the following line to an initializer:

```ruby
ActiveRecord::Base.logger = Napa::Logger.logger
```

`Napa::Logger.logger` returns a Singleton instance of the Logging object, so it can be passed to other libraries or called directly. For example:

```ruby
Napa::Logger.logger.debug 'Some Debug Message'
```
### StatsD
There are two middlewares available to enable StatsD reporting, `RequestStats` and `DatabaseStats`. They can be enabled independently in your `config.ru` file:

```
use Napa::Middleware::RequestStats
use Napa::Middleware::DatabaseStats
```

**RequestStats** will emit information about your application's request count and response time.

**DatabaseStats** will emit information from ActiveRecord about query times.

##### Configuration

To configure StatsD in your application you will need to supply the `STATSD_HOST` and `STATSD_PORT` in your environment. Optionally, if your StatsD host requires an api token (i.e. hostedgraphite), you can configure that with the `STATSD_API_KEY` environment variable.

##### Logging

If you want to see the StatsD reporting in action you can hook up the logger to the Napa logger to see the requests in your logs.

```
Statsd.logger = Napa::Logger.logger
```

### Caching

Napa adds a simple wrapper around `ActiveSupport::Cache` that allows you to easily access it similar to how it works in Rails. `Napa.cache` will give you access to all of the methods available in `ActiveSupport::Cache::Store` [http://api.rubyonrails.org/classes/ActiveSupport/Cache/Store.html](). So, for example:

```
Napa.cache.read
Napa.cache.write
Napa.cache.fetch
...
```

By default it will use `:memory_store`, but you can override it to use any other caching strategy, like Memcache by setting the store:

```
Napa.cache = :dalli_store
```

### Sorting

Napa has an optional module you can include in any Api called
`Napa::SortableApi`. To include this, add `include SortableApi` in the
`helpers` block of the Api.

`SortableApi` takes in a parameter for sort in the format of
`field1,field2,-field3`, where `field1` and `field2` are used to sort
ascending, and `field3` is sorted descending. For example,
`-field4,field1` would be equivalent to `ORDER BY field4 DESC, field1'.

Call `sorted_from_params(ar_relation, params[:sort])` passing in an
`ActiveRecord::Relation` for `ar_relation`, and a comma-delimited string of field names for `params[:sort]`.

## Bugs & Feature Requests
Please add an issue in [Github](https://github.com/bellycard/napa/issues) if you discover a bug or have a feature request.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
