unless defined?(Rails)
  desc "display all routes for Grape"
  task :routes do
    ApplicationApi.routes.each do |api|
      method  = api.route_method.ljust(10)
      path    = api.route_path
      puts    "     #{method} #{path}"
    end
  end
end
