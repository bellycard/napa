module Napa
  class Entity < Grape::Entity
    def self.inherited(subclass)
      ActiveSupport::Deprecation.warn 'Use of Napa::Entity is discouraged, please transition your code to Roar representers - https://github.com/bellycard/napa/blob/master/docs/grape_entity_to_roar.md', caller
    end

    format_with :to_s do |val|
      val.to_s
    end

    def object_type
      object.class.name.underscore
    end
  end
end