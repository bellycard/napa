module Napa
  module GrapeExtenders
    def self.extended(modified_class)
      # when extended, set the exceptions to handle
      # if AR is being used, rescue from common AR errors
      if defined?(::ActiveRecord)
        modified_class.rescue_from :all do |e|
          if e.class == ::ActiveRecord::RecordNotFound
            err = Napa::JsonError.new(:record_not_found, 'record not found')
            Napa::Logger.logger.debug(Napa::Logger.response(404, {}, err))
            rack_response(err.to_json, 404)
          elsif e.class == ::ActiveRecord::RecordInvalid
            err = Napa::JsonError.new(:unprocessable_entity, e.message, e.record.errors.messages)
            Napa::Logger.logger.debug(Napa::Logger.response(422, {}, err))
            rack_response(err.to_json, 422)
          else
            raise e
          end
        end
      end

      # if AASM is being used, rescue from invalid transitions
      if defined?(::AASM)
        modified_class.rescue_from ::AASM::InvalidTransition do |e|
          err = Napa::JsonError.new(:unprocessable_entity, e.message)
          Napa::Logger.logger.debug(Napa::Logger.response(422, {}, err))
          rack_response(err.to_json, 422)
        end
      end
    end
  end
end
