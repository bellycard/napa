module Napa
  class JsonError
    def initialize(code, message)
      @code = code
      @message = message
    end

    def to_json(options = {})
      {
        error: {
          code: @code,
          message: @message
        }
      }.to_json
    end
  end
end