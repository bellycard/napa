module Napa
  class Entity < Grape::Entity
    format_with :to_s do |val|
      val.to_s
    end

    def object_type
      object.class.name.underscore
    end
  end
end