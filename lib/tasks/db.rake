unless defined?(Rails)
  task :environment do
    require 'erb'
    require './app'

    raise "ActiveRecord Not Found" unless Module.const_defined?(:ActiveRecord)
  end

  namespace :db do
    desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
    task :migrate => :environment do
      ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
      Rake::Task["db:schema:dump"].invoke unless Napa.env.production?
    end

    desc "Create the database"
    task :create => :environment do
      db = YAML.load(ERB.new(File.read('./config/database.yml')).result)[Napa.env]

      options = {}.tap do |o|
        o[:adapter]                 = db['adapter']
        o[:database]                = 'postgres' if db['adapter'] == 'postgresql'
      end

      ActiveRecord::Base.establish_connection(options)
      ActiveRecord::Base.connection.create_database(db['database'])

    end

    desc "Delete the database"
    task :drop => :environment do
      db = YAML.load(ERB.new(File.read('./config/database.yml')).result)[Napa.env]

      options = {}.tap do |o|
        o[:adapter]                 = db['adapter']
        o[:database]                = 'postgres' if db['adapter'] == 'postgresql'
      end

      ActiveRecord::Base.establish_connection(options)
      ActiveRecord::Base.connection.drop_database(db['database'])
    end

    desc "Create the test database"
    task :reset => :environment do
      Rake::Task["db:drop"].invoke
      Rake::Task["db:create"].invoke
      Rake::Task["db:schema:load"].invoke
    end

    namespace :schema do
      desc "Create a db/schema.rb file that can be portably used against any DB supported by AR"
      task :dump => :environment do
        require 'active_record/schema_dumper'
        File.open(ENV['SCHEMA'] || "db/schema.rb", "w") do |file|
          ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
        end
      end

      desc "Load a schema.rb file into the database"
      task :load => :environment do
        file = ENV['SCHEMA'] || "db/schema.rb"
        db = YAML.load(ERB.new(File.read('./config/database.yml')).result)[Napa.env]
        ActiveRecord::Base.establish_connection(db)
        ActiveRecord::Schema.verbose = true
        load(file)
      end
    end
  end
end
