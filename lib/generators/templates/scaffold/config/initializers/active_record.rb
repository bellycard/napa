require 'erb'
db = YAML.load(ERB.new(File.read('./config/database.yml')).result)[Napa.env]
ActiveRecord::Base.establish_connection(db)
ActiveRecord::Base.logger = Napa::Logger.logger if Napa.env.development?
ActiveRecord::Base.include_root_in_json = false
