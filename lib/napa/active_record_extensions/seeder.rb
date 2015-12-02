if defined?(ActiveRecord)
  module Napa
    class ActiveRecordSeeder
      def initialize(seed_file)
        @seed_file = seed_file
      end

      def load_seed
        fail "Seed file '#{@seed_file}' does not exist" unless File.file?(@seed_file)
        load @seed_file
      end
    end
  end
end
