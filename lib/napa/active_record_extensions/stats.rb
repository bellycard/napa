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

    def self.guess_sql_content(query)
      m = query.match(SQL_UPDATE_REGEXP)
      return [m[:table], 'UPDATE'] if m
      unless m
        m = query.match(SQL_SELECT_REGEXP)
        extract_sql_selects(query) if m
      end
    end

    ActiveSupport::Notifications.subscribe 'sql.active_record' do |name, start, finish, id, payload|
      if payload[:name] == 'SQL'
        table, action = extract_from_sql_inserts_deletes(payload[:sql])
      elsif payload[:name] =~ /.* Load$/
        table, action = extract_sql_selects(payload[:sql])
      elsif !payload[:name]
        table, action = guess_sql_content(payload[:sql])
      end

      if table
        stat_context = "#{Thread.current[:stats_context] || Napa::Identity.name + '.unknown'}"
        Napa::Stats.emitter.timing(
          "#{stat_context}.sql.#{table}.#{action.downcase}.query_time",
          (finish - start) * 1000)
      end
    end
  end
end
