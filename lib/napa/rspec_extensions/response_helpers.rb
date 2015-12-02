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

      def result_count
        parsed_response.data.count
      end

      def first_result
        parsed_response.data.first
      end

      def result_with_id(id)
        parsed_response.data.select { |r| r.id == id }.first
      end

      def expect_count_of(count)
        expect(result_count).to eq(count)
      end

      def expect_error_code(error_code)
        expect(parsed_response.error.code).to eq(error_code.to_s)
      end

      def expect_only(object)
        expect_count_of 1
        expect(first_result.id).to eq(object.id)
      end

      def expect_to_have(object)
        expect(!result_with_id(object.id).nil?).to be_truthy
      end

      def expect_to_not_have(object)
        expect(!result_with_id(object.id).nil?).to be_falsy
      end
    end
  end
end
