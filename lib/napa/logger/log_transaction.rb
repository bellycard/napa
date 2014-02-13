module Napa
  class LogTransaction
    class << self
      attr_writer :id # setter method for id

      def id
        Thread.current[:napa_tid].nil? ? Thread.current[:napa_tid] = SecureRandom.hex(10) : Thread.current[:napa_tid]
      end

      # def id=(id)
      #   Thread.current[:napa_tid] = id
      # end

      def clear
        Thread.current[:napa_tid] = nil
      end
    end
  end
end
