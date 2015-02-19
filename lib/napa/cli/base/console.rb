module Napa
  module CLI
    class Base < Thor

      desc 'console [ENVIRONMENT]', 'Start the Napa console'
      options aliases: 'c'
      def console(environment = nil)
        Napa.env = environment || 'development'

        require 'racksh/init'

        begin
          require "pry"
          interpreter = Pry
        rescue LoadError
          require "irb"
          require "irb/completion"
          interpreter = IRB
          # IRB uses ARGV and does not expect these arguments.
          ARGV.delete('console')
          ARGV.delete(environment) if environment
        end

        Rack::Shell.init

        $0 = "#{$0} console"
        interpreter.start
      end

    end
  end
end
