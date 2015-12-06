# override what is in logging gem to ALWAYS use a structured object, rather than a string
# original version of this: https://github.com/TwP/logging/blob/master/lib/logging/layouts/parseable.rb
module Logging
  module Layouts
    class Parseable < ::Logging::Layout
      # Public: Take a given object and convert it into a format suitable for
      # inclusion as a log message. The conversion allows the object to be more
      # easily expressed in YAML or JSON form.
      #
      # If the object is an Exception, then this method will return a Hash
      # containing the exception class name, message, and backtrace (if any).
      #
      # If the object is a string, wrap it in a hash.
      #
      # obj - The Object to format
      #
      # Returns the formatted Object.
      #
      def format_obj(obj)
        case obj
        when Exception
          h = { class: obj.class.name,
                message: obj.message }
          h[:backtrace] = obj.backtrace if @backtrace && !obj.backtrace.nil?
          h
        when Time
          iso8601_format(obj)
        when String
          { text: obj }
        else
          obj
        end
      end
    end  # Parseable
  end  # Layouts
end
