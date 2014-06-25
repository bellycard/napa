module Napa
  module RspecExtensions
    module ResponseHelpers
      def parsed_response
        Hashie::Mash.new(JSON.parse(last_response.body))
      end

      def response_code
        last_response.status
      end

      def response_body
        last_response.body
      end
    end
  end
end
