#Napa Quickstart

Napa was designed to make it easy to quickly create a new API service. Here we will cover the steps required to create a new simple API service using Napa, Grape, Roar and ActiveRecord.

Napa is available as a Ruby gem, to install it run:

```
gem install napa
```

## Service Scaffold

In this example we will create a new API to manage a directory of people. Each person will have a `name`, `job_title` and `email_address`. To get started, create a new scaffold by running:

```
napa new people_service
```

**Note:** by default, Napa will configure itself to use Mysql. If you prefer to use Postgres, simply pass in the `-d=pg` option to the `napa new` command.

You will see the following output:

```
Generating scaffold...
      create  people_service
      create  people_service/.env.test
      create  people_service/.env
      create  people_service/.gitignore
      create  people_service/.rubocop.yml
      create  people_service/.ruby-gemset
      create  people_service/.ruby-version
      create  people_service/Gemfile
      create  people_service/README.md
      create  people_service/Rakefile
      create  people_service/app.rb
      create  people_service/app/apis/application_api.rb
      create  people_service/app/apis/hello_api.rb
      create  people_service/config.ru
      create  people_service/config/database.yml
      create  people_service/config/initializers/active_record.rb
      create  people_service/config/middleware/honeybadger.rb
      create  people_service/db/schema.rb
      create  people_service/lib/.keep
      create  people_service/log/.gitkeep
      create  people_service/spec/apis/hello_api_spec.rb
      create  people_service/spec/factories/.gitkeep
      create  people_service/spec/spec_helper.rb
Done!
```

Now, change into the `people_service` directory and run Bundler to get all the gems you need:

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

## API Generator

Now that we have our service scaffolded up, let's generate an API.

Napa include an API generator which will create a Grape API, Model and Representer by running:

```
napa generate api person
```

**Note:** the generator will pluralize the name of your resource for the API, so use the singular version in the generator.

You will see the following output:

```
Generating api...
      create  app/apis/people_api.rb
      create  app/models/person.rb
      create  app/representers/person_representer.rb
Done!
```

## Create a Person model

From the output above, we can see that the generated create a `Person` model, so we should create a migration to actually build the table for that in our database. So, let's run:

```
napa generate migration CreatePerson
```

You will see the following output:

```
Generating migration...
      create  db/migrate
      create  db/migrate/20140411163743_create_person.rb
Done!
```

Open up that migration file and add the migration to create the `people` table:

```ruby
class CreatePerson < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :job_title
      t.string :email
    end
  end
end
```

Then you can run:

```
rake db:migrate
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

Start the server on port 9393 by running:

```
shotgun
```

### POST /people

To create a person we will send a `POST` request to our API.

```
curl -X POST -d name="Darby Frey" -d job_title="Software Engineer" -d email="darbyfrey@gmail.com" http://localhost:9393/people
```

**SIDENOTE:** At this point, you will likely get an error response like the one below. By default Napa ships with the `Napa::Middleware::Authentication` enabled. For the purposes of this guide, we will disable this middleware to make the requests easier to construct. Be sure to re-enable this before you go to production. To disable the middleware, just comment out the `use Napa::Middleware::Authentication` line in `config.ru` and restart shotgun. Also, see the Napa::Middleware::Authentication docs for more details.

```json
{
  "error": {
    "code": "not_configured",
    "message": "password not configured"
  }
}
```


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

So, there you have it, a new API service in minutes. It's very basic, but you can continue to build it out from here. One thing to note, we don't generate a `DELETE` request from the generator, but you can easily add that. The resources section below will link you to the Grape docs where you can find those instructions.

## Resources

* [Code Example: people-service](https://github.com/darbyfrey/people_service)
* [Grape](http://intridea.github.io/grape/)
* [Roar](https://github.com/apotonick/roar)
