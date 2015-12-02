module Napa
  module CLI
    # directly ported with slight modification from
    # https://github.com/rails/rails/blob/76883f92374c6395f13c16628e1d87d40b6d2399/railties/lib/rails/generators/generated_attribute.rb
    class GeneratedAttribute # :nodoc:
      INDEX_OPTIONS = %w(index uniq)
      UNIQ_INDEX_OPTIONS = %w(uniq)

      attr_accessor :name, :type
      attr_reader :attr_options
      attr_writer :index_name

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

        # parse possible attribute options like :limit for string/text/binary/integer
        # :precision/:scale for decimals or :polymorphic for references/belongs_to
        # when declaring options curly brackets should be used
        def parse_type_and_options(type)
          case type
          when /(string|text|binary|integer)\{(\d+)\}/
            return Regexp.last_match[1], limit: Regexp.last_match[2].to_i
          when /decimal\{(\d+)[,.-](\d+)\}/
            return :decimal, precision: Regexp.last_match[1].to_i, scale: Regexp.last_match[2].to_i
          when /(references|belongs_to)\{polymorphic\}/
            return Regexp.last_match[1], polymorphic: true
          else
            return type, {}
          end
        end
      end

      def initialize(name, type = nil, index_type = false, attr_options = {})
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
                     when :decimal                     then '9.99'
                     when :datetime, :timestamp, :time then Time.now.to_s(:db)
                     when :date                        then Date.today.to_s(:db)
                     when :string                      then name == 'type' ? '' : 'MyString'
                     when :text                        then 'MyText'
                     when :boolean                     then false
                     when :references, :belongs_to     then nil
                     else
                       ''
        end
      end

      def factory_stub
        case type
        when :integer                     then '1'
        when :float                       then '1.5'
        when :decimal                     then '9.99'
        when :datetime, :timestamp, :time then '{ Time.now }'
        when :date                        then '{ Date.today }'
        when :string                      then '"MyString"'
        when :text                        then '"MyText"'
        when :boolean                     then 'false'
        when :digest                      then '"password"'
        else
          '"Unknown"'
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
        !(name =~ /_id$/).nil?
      end

      def reference?
        self.class.reference?(type)
      end

      def polymorphic?
        attr_options.key?(:polymorphic)
      end

      def required?
        attr_options[:required]
      end

      attr_reader :has_uniq_index, :has_index
      alias_method :has_uniq_index?, :has_uniq_index
      alias_method :has_index?, :has_index

      def password_digest?
        name == 'password' && type == :digest
      end

      def inject_options
        ''.tap { |s| @attr_options.each { |k, v| s << ", #{k}: #{v.inspect}" } }
      end

      def inject_index_options
        has_uniq_index? ? ', unique: true' : ''
      end
    end
  end
end
