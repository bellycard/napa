class ApplicationApi
  format :json
  extend Napa::ApiExceptionCatchers

  mount HelloApi => '/'

  add_swagger_documentation
end

