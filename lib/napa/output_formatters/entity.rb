module Napa
  class Entity < Grape::Entity
    LINK = 'https://github.com/bellycard/napa/blob/master/docs/grape_entity_to_roar.md'
    WARNING = "Use of Napa::Entity is discouraged, please transition your code to Roar representers - #{LINK}"
    def self.inherited(_subclass)
      ActiveSupport::Deprecation.warn WARNING, caller
    end

    format_with :to_s do |val|
      val.to_s
    end

    def object_type
      object.class.name.underscore
    end
  end
end
