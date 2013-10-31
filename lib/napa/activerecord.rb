module Napa
  class ActiveRecord
    class << self
      def migration_template(migration_class)
        <<-MIGRATION
          class #{migration_class} < ActiveRecord::Migration
            def up
              # create_table :foo do |t|
              #   t.string :name, :null => false
              # end
            end

            def down
              # drop_table :foo
            end
          end
        MIGRATION
      end
    end
  end
end