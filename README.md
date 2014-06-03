[![Build Status](https://travis-ci.org/bellycard/napa.png?branch=master)](https://travis-ci.org/bellycard/napa)
[![Dependency Status](https://gemnasium.com/bellycard/napa.png)](https://gemnasium.com/bellycard/napa)

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
  napa console                              # Start the Napa console
  napa generate api <api_name>              # Create a Grape API, Model and Representer, api_name should be plural i.e. users
  napa generate migration <migration_name>  # Create a Database Migration
  napa help [COMMAND]                       # Describe available commands or one specific command
  napa new <app_name> [app_path]            # Create a scaffold for a new Napa service
  napa version                              # Shows the Napa version number
```


### Console
Similar to the Rails console, load an IRB sesson with your applications environment by running:

```
napa console
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
rake deploy:production  # Deploy to production
rake deploy:staging     # Deploy to staging
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
The *Logger* modules is used to create a common log format across applications. The Logger is enable via a rack middleware by adding the line below to your `config.ru` file:

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

## Bugs & Feature Requests
Please add an issue in [Github](https://github.com/bellycard/napa/issues) if you discover a bug or have a feature request.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
