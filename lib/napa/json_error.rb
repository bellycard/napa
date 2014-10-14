module Napa
  class JsonError
    def initialize(code, message, details={})
      @code = code
      @message = message
      @details = details
    end

    def to_json(options = {})
      to_h.to_json(options)
    end

    def to_h
      e = {
        error: {
          code: @code,
          message: @message
        }
      }
      e[:error][:details] = @details if @details
      e
    end
  end
end
