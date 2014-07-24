if defined?(ActiveSupport) && defined?(ActiveRecord)
  module Napa
    module ActiveRecordStats
      SQL_INSERT_DELETE_PARSER_REGEXP = /^(?<action>\w+)\s(\w+)\s\W*(?<table>\w+)/
      SQL_SELECT_REGEXP = /select .*? FROM \W*(?<table>\w+)/i
      SQL_UPDATE_REGEXP = /update \W*(?<table>\w+)/i

      # Returns the table and query type
      def self.extract_from_sql_inserts_deletes(query)
        m = query.match(SQL_INSERT_DELETE_PARSER_REGEXP)
        [m[:table], m[:action]]
      end

      def self.extract_sql_selects(query)
        m = query.match(SQL_SELECT_REGEXP)
        [m[:table], 'SELECT']
      end

      def self.extract_sql_updates(query)
        m = query.match(SQL_UPDATE_REGEXP)
        [m[:table], 'UPDATE']
      end

      def self.extract_sql_content(query)
        table = action = nil
        if query.match(SQL_UPDATE_REGEXP)
          table, action = extract_sql_updates(query)
        elsif query.match(SQL_SELECT_REGEXP)
          table, action =  extract_sql_selects(query)
        elsif query.match(SQL_INSERT_DELETE_PARSER_REGEXP)
          table, action =  extract_from_sql_inserts_deletes(query)
        end
        [table, action]
      end
    end
  end
end
