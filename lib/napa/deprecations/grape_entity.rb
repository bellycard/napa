module Grape
  class Entity
    LINK = 'https://github.com/bellycard/napa/blob/master/docs/grape_entity_to_roar.md'
    WARNING = "Use of Grape::Entity is discouraged, please transition your code to Roar representers - #{LINK}"
    def self.inherited(_subclass)
      ActiveSupport::Deprecation.warn WARNING, caller
    end
  end
end
