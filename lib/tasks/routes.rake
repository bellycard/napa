unless defined?(Rails)
  desc "display all routes"
  task :routes do
    grape_apis = ObjectSpace.each_object(Class).select { |klass| klass < Grape::API }
    grape_apis.each do |api|
      api.routes.each do |r|
        puts "#{r}"
      end
    end
  end
end
