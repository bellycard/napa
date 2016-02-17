require 'active_record'

Rake.application.rake_require('active_record/railties/databases')

include ActiveRecord::Tasks

original_dir                         = Rake.application.original_dir
db_dir                               = File.join(original_dir, 'db')
config_dir                           = File.join(original_dir, 'config')
db_config_path                       = config_dir + '/database.yml'
migrations_path                      = db_dir + '/migrate'

db_config = YAML.load(ERB.new(File.read(db_config_path)).result)

DatabaseTasks.env                    = (ENV['RACK_ENV'] || 'development').to_sym
DatabaseTasks.db_dir                 = db_dir
DatabaseTasks.database_configuration = db_config
DatabaseTasks.migrations_paths       = [migrations_path]

Rake::Task.define_task(:environment) do
  ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym
end
