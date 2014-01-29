[![Build Status](https://travis-ci.org/bellycard/napa.png?branch=master)](https://travis-ci.org/bellycard/napa)

# Napa

The Napa gem is a simple framework for building APIs with Grape. These features include:

* Generator
* Console
* Identity
* Logging
* Deployment
* Grape Specific Features (Cache management and Route inspection) i.e. `rake routes`

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

Napa comes with a useful generator to quickly scaffold up a new project. Simply run:

```
$ napa new your_project_name
```

This will generate a basic application framework for you. It includes everything you need to get started including a Hello World API.

1) To get started, run Bundler to make sure you have all the gems for the project:

```
$ bundle install
```

2) Then, make sure your database connections are setup correctly. The configuration is set in the `.env` and `.env.test`. Then create your database by running:

```
$ rake db:create
```

3) Now you're ready to start up the server:

```
$ shotgun
```

4) Once the server is started, run the following command to load your service in a browser:

```
$ open http://127.0.0.1:9393/hello
```

...and you should see:

```
{
  message: "Hello Wonderful World!"
}
```

5) We've also provided a sample spec file. You can run the tests by running:

```
RACK_ENV='test' rake db:test:prepare
rspec spec
```

## Usage/Features

### Console
Similar to the Rails console, load an IRB sesson with your applications environment by running:

```
ruby console
```

### Identity
The *Identity* module exists to provide and interface to get information about the application. For example:

`Napa::Identity.name` => Returns the name of the app defined by `ENV['SERVICE_NAME']`.

`Napa::Identity.hostname` => Returns the name of the host running the application.

`Napa::Identity.revision` => Returns the current revision from Git.

`Napa::Identity.pid` => Returns the current running process id.

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

### Deployment
At Belly we leverage a git based deployment process, so we've included some rake tasks we use to automate deployments. These tasks will essentially just tag a commit with `production` or `staging` so that it can be picked up by a separate deployment process.

The tasks currently available are:

```ruby
rake deploy:staging
```


```ruby
rake deploy:production
```

**Please Note:** These tasks rely on two environment variables - `GITHUB_OAUTH_TOKEN` and `GITHUB_REPO`. For more information, see **Environment Variables** below.

### Grape Specific Features
At Belly we use the [Grape Micro-Framework](https://github.com/intridea/grape) for many services, so we've included a few common features.

#### Cache Managment
Cache control headers are sent with Grape API responses to prevent clients from caching responses unexpectedly. This feature is enabled by default, so you don't have to make any changes to enable it.

#### Route Inspection
A rake task is included to give you a Rails style list of your routes. Simpley run:

```ruby
rake routes
```

### Environment Variables
Napa expects to find some environment variables set in your application in order for some features to work. A list is below:

#### SERVICE_NAME
The name of your app or service, used by Identity and as a label for your logs

#### GITHUB\_OAUTH\_TOKEN
Used to grant access to your application on Github for deployment tagging

#### GITHUB_REPO
Your application's Github repo. i.e. `bellycard/napa`

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Todo/Feature Requests

* Add specs for logger and logging middleware