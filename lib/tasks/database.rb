unless defined?(Rails)
  if ActiveRecord::VERSION::MAJOR >= 4
    require File.expand_path('database/current', File.dirname(__FILE__))
  else
    require File.expand_path('database/legacy', File.dirname(__FILE__))
  end
end
