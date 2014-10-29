module Napa
  class JsonError
    def initialize(code, message, reasons={})
      @code = code
      @message = message
      @reasons = reasons
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
      e[:error][:reasons] = @reasons if @reasons
      e
    end
  end
end
