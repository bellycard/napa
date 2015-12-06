module Napa
  module CLI
    class Base < Thor
      desc 'server', 'Start the Napa server'
      options aliases: 's'
      def server
        puts 'Napa server starting...'

        require 'pty'
        exit = '... Napa server exited!'

        begin
          PTY.spawn('shotgun') do |stdout, _stdin, pid|
            begin
              Signal.trap('INT') { Process.kill('INT', pid) }
              stdout.each { |line| puts line }
            rescue Errno::EIO
              puts exit
            end
          end
        rescue PTY::ChildExited
          puts exit
        end
      end
    end
  end
end
