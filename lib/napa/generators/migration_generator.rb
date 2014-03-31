require 'thor'
require 'active_support/all'

module Napa
  module Generators
    class MigrationGenerator < Thor::Group
      include Thor::Actions
      argument :migration_name

      def version
        Time.now.utc.to_s.gsub(':','').gsub('-','').gsub('UTC','').gsub(' ','')
      end

      def migration_filename
        "#{version}_#{migration_name.underscore}"
      end

      def migration
        self.class.source_root "#{File.dirname(__FILE__)}/templates/migration"
        say 'Generating migration...'
        directory '.', './db/migrate'
        say 'Done!', :green
      end
    end
  end
end