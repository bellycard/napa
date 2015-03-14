require 'erb'
class ActiveRecordConnection
  def self.start
    require 'erb'
    pool_size = ENV['ACTIVE_RECORD_POOL_SIZE'] ? ENV['ACTIVE_RECORD_POOL_SIZE'] : 5
    db = YAML.load(ERB.new(File.read('./config/database.yml')).result)[Napa.env]
    ActiveRecord::Base.establish_connection(db.merge(pool: pool_size))
    ActiveRecord::Base.logger = Napa::Logger.logger if Napa.env.development?
    ActiveRecord::Base.include_root_in_json = false
    I18n.enforce_available_locales = true
  end

  def self.teardown
    ActiveRecord::Base.remove_connection
  end
end
