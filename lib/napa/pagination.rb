module Napa
  class Pagination
    def initialize(object)
      @object = object
    end

    def to_json(options = {})
      to_h.to_json(options)
    end

    def to_h
      {}.tap do |p|
        p[:page]          = @object.current_page  if @object.respond_to?(:current_page)
        p[:per_page]      = @object.limit_value   if @object.respond_to?(:limit_value)
        p[:total_pages]   = @object.total_pages   if @object.respond_to?(:total_pages)
        p[:total_count]   = @object.total_count   if @object.respond_to?(:total_count)
      end
    end
  end
end