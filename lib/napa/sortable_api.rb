if defined?(ActiveRecord)
  module Napa
    module SortableApi
      def sort_from_params(objects, sort_params)
        return objects if sort_params.nil?

        sort_fields = sort_params.split(',')
        sort_fields.each do |sort_field|
          sort_field = (sort_field[1..-1] + ' DESC') if sort_field.start_with?('-')
          objects = objects.order(sort_field)
        end

        objects
      end
    end
  end
end
