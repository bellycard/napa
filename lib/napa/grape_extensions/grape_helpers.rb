module Napa
  module GrapeHelpers
    def represent(data, with: nil, **args)
      raise ArgumentError.new(":with option is required") if with.nil?

      if data.respond_to?(:to_a)
        return {}.tap do |r|
          r[:data] = data.map{ |item| with.new(item).to_hash(args) }
          r[:pagination] = Napa::Pagination.new(paginate(data)).to_h
        end
      else
        return { data: with.new(data).to_hash(args)}
      end
    end

    def paginate(data)
      # don't paginate if collection is already paginated
      return data if data.respond_to?(:total_count)

      page      = params.try(:page) || 1
      per_page  = params.try(:per_page) || 25

      if data.is_a?(Array)
        Kaminari.paginate_array(data).page(page).per(per_page)
      else
        data.page(page).per(per_page)
      end
    end

    def present_error(code, message = '')
      Napa::JsonError.new(code, message)
    end

    def permitted_params(options = {})
      options = { include_missing: false }.merge(options)
      declared(params, options)
    end

    # extend all endpoints to include this
    Grape::Endpoint.send :include, self
  end
end
