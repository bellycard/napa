require 'grape'
class Napa::GrapeAPI < Grape::API
  def after
    @app_response[1]['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
    @app_response[1]['Pragma'] = 'no-cache'
    @app_response[1]['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
    @app_response
  end
end
