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
    grape_apis.include(:routes).each do |api| # optimize database call to include all routes when calling each method on grape_apis. Pulls all data necessary in one call rather than two.
      api.routes.each do |r|
        puts "#{r}"
      end
    end
  end
end
