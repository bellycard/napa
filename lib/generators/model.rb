module Napa
  module Generators
    class Model
      def initialize(model_name)
        @model_name = model_name
        @template_path = File.expand_path(File.join(File.dirname(__FILE__), 'templates/model'))
        @files = file_list

        create_files!

        STDOUT.write "Generator Finished!\n"
      end

      def file_list
        [
          "app/apis/plural_model_name_api.rb",
          "app/models/model_name.rb",
          "app/entities/model_name_camelEntity.rb",
          "spec/apis/plural_model_name_api_spec.rb",
        ]
      end

      def create_files!
        @files.each do |file|
          create_file_with_template(file)
        end
      end

      def sub_strings(str)
        str.gsub!(/model_name_camel_plural/, @model_name.camelize.pluralize)
        str.gsub!(/plural_model_name/, @model_name.underscore.pluralize)
        str.gsub!(/model_name_camel/, @model_name.camelize)
        str.gsub!(/model_name/, @model_name.underscore)
        str
      end

      def create_file_with_template(file)
        template_file = [@template_path, file].join('/')
        new_file      = [sub_strings(file)].join('/')

        FileUtils.mkdir_p(File.dirname(new_file))

        if File.exists?(template_file)
          file_content = File.read(template_file)

          # replace template variables
          sub_strings(file_content)
          # file_content.gsub!(/{{model_name}}/, @model_name)
          # file_content.gsub!(/{{plural_model_name}}/, @model_name.pluralize)
          File.open(new_file, 'w') { |f| f.write(file_content) }
        else
          FileUtils.touch(new_file)
        end

        STDOUT.write "Creating File: #{new_file}\n"
      end
    end
  end
end
