module Napa
  module ActiveRecordExceptionCatchers
    def handle_active_record_errors
      if defined?(ActiveRecord)
        rescue_from ::ActiveRecord::RecordNotFound do |e|
          rack_response({ error: { code: :record_not_found, message: 'record not found' } }.to_json, 404)
        end
        rescue_from ::ActiveRecord::RecordInvalid do |e|
          rack_response({ error: { code: :record_invalid, message: e.message } }.to_json, 500)
        end
      end
    end
  end
end
