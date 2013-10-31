module Napa
  VERSION = "0.1.1"

  class Version
    class << self
      def next_major
        self.next_level(:major)
      end

      def next_minor
        self.next_level(:minor)
      end

      def next_patch
        self.next_level(:patch)
      end

      def next_level(level)
        raise "Unidentified Level" unless [:major,:minor,:patch].include?(level)

        parts = Napa::VERSION.split('.').map{|p| p.to_i}

        if level == :major
          parts[0] += 1 
          significant_index = 1
        end

        if level == :minor
          parts[1] += 1 
          significant_index = 2    
        end

        if level == :patch
          parts[2] += 1 
          significant_index = 3
        end

        parts.map.with_index{|p,i| parts[i] = 0 if i >= significant_index}

        parts.join('.')
      end

    end
  end
end
