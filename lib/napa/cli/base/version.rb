require 'napa/version'

module Napa
  module CLI
    class Base < Thor
      desc 'version', 'Shows the Napa version number'
      def version
        say Napa::VERSION
      end
    end
  end
end
