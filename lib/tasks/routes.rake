unless defined?(Rails)
  desc "display all routes for Grape"
  task :routes do
    grape_apis = ObjectSpace.each_object(Class).select do |klass|
      begin
        klass < Grape::API
      rescue
        false
      end
    end
    grape_apis.each do |api|
      api.routes.each do |r|
        puts "#{r}"
      end
    end
  end
end
