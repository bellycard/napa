module Napa
  class JsonError
    def initialize(code, message)
      @code = code
      @message = message
    end

    def to_json(options = {})
      to_h.to_json(options)
    end

    def to_h
      {
        error: {
          code: @code,
          message: @message
        }
      }
    end
  end
end
