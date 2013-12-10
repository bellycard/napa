module Napa
  module ErrorPresenter
    def present_error(code, message = '')
      Napa::JsonError.new(code, message)
    end

    # extend all endpoints to include this
    Grape::Endpoint.send :include, self
  end
end