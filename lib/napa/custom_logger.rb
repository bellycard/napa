module CustomLogger
  extend self

  def define_log_methods( logger )
    ::Logging::LEVELS.each do |name,num|
      code =  "undef :#{name}  if method_defined? :#{name}\n"
      code << "undef :#{name}? if method_defined? :#{name}?\n"

      if logger.level > num
        code << <<-CODE
          def #{name}?( ) false end
          def #{name}( data = nil ) false end
        CODE
      else
        code << <<-CODE
          def #{name}?( ) true end
          def #{name}( data = nil )
            data = yield if block_given?
            if data.kind_of?(Hash)
              data = data.map { |k, v| k.to_s + '=' + v.to_s }.join(' ')
            end
            log_event(::Logging::LogEvent.new(@name, #{num}, data, @caller_tracing))
            true
          end
        CODE
      end

      logger._meta_eval(code, __FILE__, __LINE__)
    end
    logger
  end
end
