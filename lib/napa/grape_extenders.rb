module Napa
  module GrapeExtenders
    def self.extended(modified_class)
      # when extended, set the exceptions to handle

      # if AR is being used, rescue from common AR errors
      if defined?(::ActiveRecord)
        modified_class.rescue_from ::ActiveRecord::RecordNotFound do |e|
          rack_response(Napa::JsonError.new(:record_not_found, 'record not found').to_json, 404)
        end
        modified_class.rescue_from ::ActiveRecord::RecordInvalid do |e|
          rack_response(Napa::JsonError.new(:record_invalid, 'record not found').to_json, 500)
        end
      end
    end
  end
end
