class Napa::Entity
  def self.inherited(subclass)
    ActiveSupport::Deprecation.warn 'Use of Napa::Entity is discouraged, please transition your code to Roar representers - https://github.com/bellycard/napa/blob/master/docs/grape_entity_to_roar.md', caller
  end
end

class Grape::Entity
  def self.inherited(subclass)
    ActiveSupport::Deprecation.warn 'Use of Grape::Entity is discouraged, please transition your code to Roar representers - https://github.com/bellycard/napa/blob/master/docs/grape_entity_to_roar.md', caller
  end
end
