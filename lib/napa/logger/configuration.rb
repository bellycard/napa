module Napa
  class Logger
    class Configuration

      def initialize(options = {})
        @options = {}.tap do |o|
          o[:format] = :basic if Napa.env.development? || ENV['DYNO']
          o[:output] = [:stdout] if ENV['DYNO']
        end

        @options.merge!(options)
      end

      def format
        # Allowed options: :basic, :yaml, :json
        @options[:format] || :json
      end

      def output
        # Allowed options: :stdout, :file
        @options[:output] ? Array.wrap(@options[:output]) : [:stdout, :file]
      end

      def request_level
        # :info, :debug, :warning, etc.
        @options[:request_level] || :info
      end

      def response_level
        # :info, :debug, :warning, etc.
        @options[:response_level] || :debug
      end

    end
  end
end
