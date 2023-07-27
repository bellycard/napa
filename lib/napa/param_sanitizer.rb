require 'action_dispatch/http/filter_parameters'

module Napa
  module ParamSanitizer
    include ActionDispatch::Http::FilterParameters

    mattr_accessor :filter_params
    PAIR_REGEXP = /([^&;=]+)=([^&;=]+)/

    def filter_params
      @@filter_params || []
    end

    def parameter_filter
      parameter_filter_for(filter_params)
    end

    def filtered_parameters(params)
      parameter_filter.filter(params)
    end

    def filtered_query_string(query_string)
      query_string.gsub(PAIR_REGEXP) do |_|
        parameter_filter.filter({ Regexp.last_match[1] => Regexp.last_match[2] }).first.join('=')
      end
    end
  end
end
