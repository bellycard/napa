module Napa
  class JsonError
    def initialize(code, message)
      @code = code
      @message = message
    end

    def to_json(options = {})
      to_h.to_json
    end

    def to_h(options = {})
      {
        error: {
          code: @code,
          message: @message
        }
      }
    end
  end
end
