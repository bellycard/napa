require 'thor'
require 'active_support/all'
require 'napa/cli/generated_attribute'

module Napa
  module CLI
    class Migration < Thor::Group
      include Thor::Actions
      # largely ported over, with a few differences, from
      # https://github.com/rails/rails/blob/76883f92374c6395f13c16628e1d87d40b6d2399/activerecord/lib/rails/generators/active_record/migration/migration_generator.rb
      argument :migration_name
      argument :attributes, type: :array, default: []

      attr_reader :migration_action, :join_tables, :table_name

      def version
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

      def migration_filename
        "#{version}_#{migration_name.underscore}"
      end

      def output_directory
        './db/migrate'
      end

      def parse_attributes!
        self.attributes = (attributes || []).map do |attr|
          GeneratedAttribute.parse(attr)
        end
      end

      def set_local_assigns!
        @migration_template = "migration"
        filename = migration_name.underscore
        case filename
        when /^(add|remove)_.*_(?:to|from)_(.*)/
          @migration_action = $1
          @table_name       = $2.pluralize
        when /join_table/
          if attributes.length == 2
            @migration_action = 'join'
            @join_tables      = attributes.map(&:plural_name)

            set_index_names
          end
        when /^create_(.+)/
          @table_name = $1.pluralize
          @migration_template = "create_table_migration"
        end
      end

      def migration
        self.class.source_root "#{File.dirname(__FILE__)}/templates/#{@migration_template}"
        say 'Generating migration...'
        directory '.', output_directory
        say 'Done!', :green
      end

      private
        def attributes_with_index
          attributes.select { |a| !a.reference? && a.has_index? }
        end

        def set_index_names
          attributes.each_with_index do |attr, i|
            attr.index_name = [attr, attributes[i - 1]].map{ |a| index_name_for(a) }
          end
        end

        def index_name_for(attribute)
          if attribute.foreign_key?
            attribute.name
          else
            attribute.name.singularize.foreign_key
          end.to_sym
        end
    end
  end
end
