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
      adapter = db.merge({'database'=> 'mysql'})
      ActiveRecord::Base.establish_connection(adapter)
      ActiveRecord::Base.connection.create_database(db.fetch('database'))
    end

    desc "Delete the database"
    task :drop => :environment do
      db = YAML.load(ERB.new(File.read('./config/database.yml')).result)[Napa.env]
      adapter = db.merge({'database'=> 'mysql'})
      ActiveRecord::Base.establish_connection(adapter)
      ActiveRecord::Base.connection.drop_database(db.fetch('database'))
    end

    desc "Create the test database"
    task :reset => :environment do
      Rake::Task["db:drop"].invoke
      Rake::Task["db:create"].invoke
      Rake::Task["db:schema:load"].invoke
    end

    namespace :generate do
      desc "Generate a migration with given name. Specify migration name with NAME=my_migration_name"
      task :migration => :environment do
        raise "Please specify desired migration name with NAME=my_migration_name" unless ENV['NAME']

        # Find migration name from env
        migration_name = ENV['NAME'].strip.chomp

        # Define migrations path (needed later)
        migrations_path = './db/migrate'

        # Find the highest existing migration version or set to 1
        if (existing_migrations = Dir[File.join(migrations_path, '*.rb')]).length > 0
          version = File.basename(existing_migrations.sort.reverse.first)[/^(\d+)_/,1].to_i + 1
        else
          version = 1
        end

        # Use the migration template to fill the body of the migration
        migration_content = Napa::ActiveRecord.migration_template(migration_name.camelize)

        # Generate migration filename
        migration_filename = "#{"%03d" % version}_#{migration_name}.rb"

        # Write the migration
        File.open(File.join(migrations_path, migration_filename), "w+") do |migration|
          migration.puts migration_content
        end

        # Done!
        puts "Successfully created migration #{migration_filename}"
      end
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
        load(file)
      end
    end
  end
end