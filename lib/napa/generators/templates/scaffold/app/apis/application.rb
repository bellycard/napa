module Application
  class API < Grape::API
    format :json
    extend Napa::ActiveRecordExceptionCatchers
    handle_active_record_errors

    mount HelloApi => '/'

    add_swagger_documentation
  end
end
