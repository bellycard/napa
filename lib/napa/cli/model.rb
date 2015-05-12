require 'thor'
require 'active_support/all'
require 'napa/cli/generated_attribute'

module Napa
  module CLI
    class Error < Thor::Error # :nodoc:
    end

    # Note: This currently does not support namespaced model creation.
    class Model < Thor::Group
      include Thor::Actions

      # Largely modeled off of Rails's:
      #  - activerecord/lib/rails/generators/active_record/model/model_generator.rb,
      #  - railties/lib/rails/generators/base.rb, and
      #  - railties/lib/rails/generators/named_base.rb

      argument :name
      argument :attributes, :type => :array, :default => []

      class_option :migration,  :type => :boolean, :default => true
      class_option :timestamps, :type => :boolean, :default => true
      class_option :indexes,    :type => :boolean, :default => true
      class_option :parent,     :type => :string

      def parse_attributes!
        self.attributes = (attributes || []).map do |attr|
          GeneratedAttribute.parse(attr)
        end
      end

      def generate_model
        # In order to check for class collisions, the Grape environment needs to be loaded.
        say 'Generating model...'
        self.class.source_root "#{File.dirname(__FILE__)}/templates"
        create_migration_file
        create_model_file
        create_factory_file
        create_model_spec_file
        say 'Done!', :green
      end

      protected

      def version
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

      def create_migration_file
        return unless options[:migration] && options[:parent].nil?
        attributes.each { |a| a.attr_options.delete(:index) if a.reference? && !a.has_index? } if options[:indexes] == false

        # This does not currently check for similar migrations.
        #   This can be done by overriding the CreateFile Thor action and
        #   implementing the exists? and on_conflict_behavior methods.
        template migration_template, "#{migration_output_directory}/#{version}_#{migration_name}.rb"
      end

      def create_model_file
        template model_template, "#{model_output_directory}/#{model_name}.rb"
      end

      def create_factory_file
        template factory_template, "#{factory_output_directory}/#{table_name}.rb"
      end

      def create_model_spec_file
        template model_spec_template, "#{model_spec_output_directory}/#{model_name}_spec.rb"
      end

      def model_name
        name.underscore
      end

      def migration_name
        "create_#{table_name}"
      end

      def table_name
        model_name.pluralize
      end

      def migration_template
        "model/db/migrate/migration.rb.tt"
      end

      def parent_class_name
        options[:parent] || "ActiveRecord::Base"
      end

      def migration_output_directory
        './db/migrate'
      end

      def model_template
        "model/app/models/model.rb.tt"
      end

      def model_output_directory
        './app/models'
      end

      def factory_template
        "model/spec/factories/factory.rb.tt"
      end

      def factory_output_directory
        './spec/factories'
      end

      def model_spec_template
        "model/spec/models/model_spec.rb.tt"
      end

      def model_spec_output_directory
        './spec/models'
      end

      def attributes_with_index
        attributes.select { |a| !a.reference? && a.has_index? }
      end

      def accessible_attributes
        attributes.reject(&:reference?)
      end

    end
  end
end
