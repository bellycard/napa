require 'erb'

ActiveRecord::Base.logger = Napa::Logger.logger if Napa.env.development?
ActiveRecord::Base.include_root_in_json = false

db_config = ENV['DATABASE_URL'] || YAML.load(ERB.new(File.read('./config/database.yml')).result)[Napa.env]
db_connection = ActiveRecord::Base.establish_connection(db_config)
ActiveRecord::Base.configurations['db'] = db_connection.spec.config
