if Napa.env.test?
  ActiveSupport::Deprecation.behavior = :stderr
else
  ActiveSupport::Deprecation.behavior = ->(message, callstack) {
    # ignoring callstack for now because it's fairly noisy
    Napa::Logger.logger.info(napa_deprecation_warning: message)
  }
end
