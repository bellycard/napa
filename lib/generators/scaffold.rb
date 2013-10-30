module Napa
  module Generators
    class Scaffold
      def initialize(app_name, app_path=nil)
        @app_name = app_name
        @app_path = app_path.nil? ? app_name : app_path
        @template_path = File.expand_path(File.join(File.dirname(__FILE__), 'templates/scaffold'))
        @files = file_list

        create_files!

        STDOUT.write "Generator Finished!"
      end

      def file_list
        files = [
          "app/apis/hello_api.rb",
          "app/models/.keep",
          "config/database.yml",
          "config/initializers/active_record.rb",
          "config/middleware/honeybadger.rb",
          "db/migrate/migration.template",
          "lib/tasks/db.rake",
          "log/.keep",
          "public/.keep",
          "spec/spec_helper.rb",
          "spec/apis/hello_api_spec.rb",
          "tmp/.keep",
          ".env",
          ".env.test",
          ".gitignore",
          "app.rb",
          "config.ru",
          "console",
          "Gemfile",
          "Rakefile",
          "README.md"
        ]
      end

      def create_files!
        @files.each do |file|
          create_file_with_template(file)
        end
      end

      def create_file_with_template(file)
        template_file = [@template_path, file].join("/")
        new_file      = [@app_name, file.gsub(/.tpl$/,'')].join("/")

        FileUtils.mkdir_p(File.dirname(new_file))

        if File.exists?(template_file)
          file_content = File.read(template_file)

          # replace template variables
          file_content.gsub!(/{{app_name}}/, @app_name)
          File.open(new_file, 'w') { |file| file.write(file_content) }
        else
          FileUtils.touch(new_file)
        end

        STDOUT.write "Creating File: #{new_file}\n"
      end
    end
  end
end