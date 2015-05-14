#Napa Quickstart

Napa was designed to make it easy to quickly create a new API service. Here we will cover the steps required to create a new simple API service using Napa, Grape, Roar and ActiveRecord.

Napa is available as a Ruby gem, to install it run:

```
gem install napa
```

## Service Scaffold

In this example we will create a new API to manage a directory of people. Each person will have a `name`, `job_title` and `email_address`. To get started, create a new scaffold by running:

```
napa new people-service
```

**Note:** by default, Napa will configure itself to use Mysql. If you prefer to use Postgres, simply pass in the `-d=pg` option to the `napa new` command.

You will see the following output:

```
Generating scaffold...
      create  people-service
      create  people-service/.env.test
      create  people-service/.env
      create  people-service/.gitignore
      create  people-service/.rubocop.yml
      create  people-service/.ruby-gemset
      create  people-service/.ruby-version
      create  people-service/Gemfile
      create  people-service/README.md
      create  people-service/Rakefile
      create  people-service/app.rb
      create  people-service/app/apis/application_api.rb
      create  people-service/app/apis/hello_api.rb
      create  people-service/config.ru
      create  people-service/config/database.yml
      create  people-service/config/initializers/active_record.rb
      create  people-service/config/middleware/honeybadger.rb
      create  people-service/db/schema.rb
      create  people-service/lib/.keep
      create  people-service/log/.gitkeep
      create  people-service/spec/apis/hello_api_spec.rb
      create  people-service/spec/factories/.gitkeep
      create  people-service/spec/spec_helper.rb
Done!
```

Now, change into the `people-service` directory and run Bundler to get all the gems you need:

```
bundle install
```

Once Bundler is done, you can create your databases by running:

```
rake db:reset
RACK_ENV=test rake db:reset
```

These tasks will look into the `.env` and `.env.test` files and drop, create and migrate the databases.

Once your databases are setup, you can run `rspec` to verify everything is working. The Napa generator includes a sample API and spec file in it's scaffold.

```
rspec spec
```

## Model Generator

Now that we have our service scaffolded up, let's generate the data model for our service.

Napa includes a Model generator that will create an ActiveRecord model, the associated database migration, a factory stub for testing, and an initial rspec test. To invoke this, run:

```
napa generate model Person name:string job_title:string email:string
```

You will see the following output:

```
Generating model...
      create  db/migrate/20140411163743_create_people.rb
      create  app/models/person.rb
      create  spec/factories/people.rb
      create  spec/models/person_spec.rb
Done!
```

Now we're ready to create and setup our databases by running:

```
rake db:migrate
RACK_ENV=test rake db:migrate
```

## API Generator

Next, let's generate an API to expose this information. Napa also includes an API generator which will create a Grape API, Model and Representer by running:

```
napa generate api person
```

**Note:** the generator will pluralize the name of your resource for the API, so use the singular version in the generator.

You will see the following output:

```
Generating api...
      create  app/apis/people_api.rb
      create  app/representers/person_representer.rb
      create  spec/apis/people_api_spec.rb
Done!
```

## Declare these attributes in the API and Representer

To provide a more secure API, the Napa generator requires you to declare any parameters your API will accept. This is done in the `params` blocks related to the specific request. In this case we will want to declare the params in `people_api.rb` for `POST` and `PUT` to be:

### POST

```ruby
desc 'Create a person'
params do
  optional :name, type: String, desc: 'The Name of the person'
  optional :job_title, type: String, desc: 'The Job Title of the person'
  optional :email, type: String, desc: 'The Email Address of the person'
end
```

### PUT
```ruby
desc 'Update a person'
params do
  optional :name, type: String, desc: 'The Name of the person'
  optional :job_title, type: String, desc: 'The Job Title of the person'
  optional :email, type: String, desc: 'The Email Address of the person'
end
```

Then, finally, add these new fields to the `person_representer.rb` so they will be returned from the API response.

```ruby
class PersonRepresenter < Napa::Representer
  property :id, type: String
  property :name
  property :job_title
  property :email
end
```

## Wire it all up

The last thing you'll need to do is mount your new endpoint into the `ApplicationApi`. Your file will look like this:

```ruby
class ApplicationApi < Grape::API
  format :json
  extend Napa::GrapeExtenders

  mount PeopleApi => '/people'

  add_swagger_documentation
end
```

Tada, you now have an API!

## Send some requests

Now that the code is in place, let's start up the app and send it some requests.

Napa runs on Rack, so any rack based webserver will work. Shotgun is nice to use in development because it will reload your app on each request and you don't need to restart the server when there are changes.

Start the shotgun server on port 9393 by running:

```
napa server
```

### POST /people

To create a person we will send a `POST` request to our API.

```
curl -X POST -d name="Darby Frey" -d job_title="Software Engineer" -d email="darbyfrey@gmail.com" http://localhost:9393/people
```

**SIDENOTE:** Napa ships with authentication support via the `Napa::Middleware::Authentication` middleware. This middleware is disabled by default, but can be enabled by uncommenting the `use Napa::Middleware::Authentication` line in `config.ru` and restarting shotgun. Also, see the Napa::Middleware::Authentication docs for more details.

All response from Napa include the `data` key. In this case the newly created person object is returned nested within the `data` key.

```json
{
  "data": {
    "object_type": "person",
    "id": "1",
    "name": "Darby Frey",
    "job_title": "Software Engineer",
    "email": "darbyfrey@gmail.com"
  }
}
```

### GET /people

```
curl -X GET http://localhost:9393/people
```
All response from Napa include the `data` key. In this case, we see an array containing just one user object.

```json
{
  "data": [
    {
      "object_type": "person",
      "id": 1,
      "name": "Darby Frey",
      "job_title": "Software Engineer",
      "email": "darbyfrey@gmail.com"
    }
  ]
}
```

### GET /people/:person_id

```
curl -X GET http://localhost:9393/people/1
```

```json
{
  "data": {
    "object_type": "person",
    "id": "1",
    "name": "Darby Frey",
    "job_title": "Software Engineer",
    "email": "darbyfrey@gmail.com"
  }
}
```

### PUT /people/:person_id

```
curl -X PUT -d job_title="Doctor Pepper" http://localhost:9393/people/1
```

```json
{
  "data": {
    "object_type": "person",
    "id": "1",
    "name": "Darby Frey",
    "job_title": "Doctor Pepper",
    "email": "darbyfrey@gmail.com"
  }
}
```

## README Generator

Now that you have an API service, time to document it!

```
napa generate readme
```

**Note:** Napa will have generated a README already, so you'll most likely see the conflict below

You will see the following output:

```
Generating readme...
       exist
    conflict  README.md
Overwrite /Users/main/workspace/napa/README.md? (enter "h" for help) [Ynaqdh] y
       force  README.md
      create  spec/docs/readme_spec.rb
Done!
```

Go through the formatted README and fill out all of the sections that have a :bow:

- - -

So, there you have it, a new API service in minutes. It's very basic, but you can continue to build it out from here. One thing to note, we don't generate a `DELETE` request from the generator, but you can easily add that. The resources section below will link you to the Grape docs where you can find those instructions.

## Resources

* [Code Example: people_service](https://github.com/darbyfrey/people_service)
* [Grape](http://intridea.github.io/grape/)
* [Roar](https://github.com/apotonick/roar)
