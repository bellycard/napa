module Napa
  module Generators
  end
end

Dir['./lib/napa/generators/*_generator.rb'].each { |file| require file }
