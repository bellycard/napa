if defined?(ActiveRecord)
  module Napa
    module FilterByHash
      module ClassMethods
        def filter(search_hash = {})
          # pass an empty where clause to force results to be a relation that will be lazy evaluated
          results = where({})
          search_hash.each do |k, v|
            results = results.where(k => v)
          end
          results
        end
      end

      def self.included(base)
        ActiveSupport::Deprecation.warn 'Napa::FilterByHash is deprecated, this module will be removed in future releases', caller
        base.extend(ClassMethods)
      end
    end
  end
end
