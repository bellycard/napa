module Napa
  module GrapeExtenders
    def self.extended(modified_class)
      # when extended, set the exceptions to handle
      # if AR is being used, rescue from common AR errors
      modified_class.rescue_from :all do |e|
        if defined?(::ActiveRecord) and e.class == ::ActiveRecord::RecordNotFound
          err = Napa::JsonError.new(:record_not_found, 'record not found')
          Napa::Logger.logger.debug(Napa::Logger.response(404, {}, err))
          rack_response(err.to_json, 404)
        elsif defined?(::ActiveRecord) and e.class == ::ActiveRecord::RecordInvalid
          err = Napa::JsonError.new(:unprocessable_entity, e.message, e.record.errors.messages)
          Napa::Logger.logger.debug(Napa::Logger.response(422, {}, err))
          rack_response(err.to_json, 422)
        elsif defined?(::AASM) and e.class == ::AASM::InvalidTransition
          err = Napa::JsonError.new(:unprocessable_entity, e.message)
          Napa::Logger.logger.debug(Napa::Logger.response(422, {}, err))
          rack_response(err.to_json, 422)
        else
          raise e
        end
      end
    end
  end
end
