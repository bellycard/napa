require 'thor'
require 'active_support/all'

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

    # directly ported from
    # https://github.com/rails/rails/blob/76883f92374c6395f13c16628e1d87d40b6d2399/railties/lib/rails/generators/generated_attribute.rb
    class GeneratedAttribute # :nodoc:
      INDEX_OPTIONS = %w(index uniq)
      UNIQ_INDEX_OPTIONS = %w(uniq)

      attr_accessor :name, :type
      attr_reader   :attr_options
      attr_writer   :index_name

      class << self
        def parse(column_definition)
          name, type, has_index = column_definition.split(':')

          # if user provided "name:index" instead of "name:string:index"
          # type should be set blank so GeneratedAttribute's constructor
          # could set it to :string
          has_index, type = type, nil if INDEX_OPTIONS.include?(type)

          type, attr_options = *parse_type_and_options(type)
          type = type.to_sym if type

          if type && reference?(type)
            references_index = UNIQ_INDEX_OPTIONS.include?(has_index) ? { unique: true } : true
            attr_options[:index] = references_index
          end

          new(name, type, has_index, attr_options)
        end

        def reference?(type)
          [:references, :belongs_to].include? type
        end

        private

        # parse possible attribute options like :limit for string/text/binary/integer, :precision/:scale for decimals or :polymorphic for references/belongs_to
        # when declaring options curly brackets should be used
        def parse_type_and_options(type)
          case type
          when /(string|text|binary|integer)\{(\d+)\}/
            return $1, limit: $2.to_i
          when /decimal\{(\d+)[,.-](\d+)\}/
            return :decimal, precision: $1.to_i, scale: $2.to_i
          when /(references|belongs_to)\{polymorphic\}/
            return $1, polymorphic: true
          else
            return type, {}
          end
        end
      end

      def initialize(name, type=nil, index_type=false, attr_options={})
        @name           = name
        @type           = type || :string
        @has_index      = INDEX_OPTIONS.include?(index_type)
        @has_uniq_index = UNIQ_INDEX_OPTIONS.include?(index_type)
        @attr_options   = attr_options
      end

      def field_type
        @field_type ||= case type
          when :integer              then :number_field
          when :float, :decimal      then :text_field
          when :time                 then :time_select
          when :datetime, :timestamp then :datetime_select
          when :date                 then :date_select
          when :text                 then :text_area
          when :boolean              then :check_box
          else
            :text_field
        end
      end

      def default
        @default ||= case type
          when :integer                     then 1
          when :float                       then 1.5
          when :decimal                     then "9.99"
          when :datetime, :timestamp, :time then Time.now.to_s(:db)
          when :date                        then Date.today.to_s(:db)
          when :string                      then name == "type" ? "" : "MyString"
          when :text                        then "MyText"
          when :boolean                     then false
          when :references, :belongs_to     then nil
          else
            ""
        end
      end

      def plural_name
        name.sub(/_id$/, '').pluralize
      end

      def singular_name
        name.sub(/_id$/, '').singularize
      end

      def human_name
        name.humanize
      end

      def index_name
        @index_name ||= if polymorphic?
          %w(id type).map { |t| "#{name}_#{t}" }
        else
          column_name
        end
      end

      def column_name
        @column_name ||= reference? ? "#{name}_id" : name
      end

      def foreign_key?
        !!(name =~ /_id$/)
      end

      def reference?
        self.class.reference?(type)
      end

      def polymorphic?
        self.attr_options.has_key?(:polymorphic)
      end

      def has_index?
        @has_index
      end

      def has_uniq_index?
        @has_uniq_index
      end

      def password_digest?
        name == 'password' && type == :digest
      end

      def inject_options
        "".tap { |s| @attr_options.each { |k,v| s << ", #{k}: #{v.inspect}" } }
      end

      def inject_index_options
        has_uniq_index? ? ", unique: true" : ""
      end
    end
  end
end
