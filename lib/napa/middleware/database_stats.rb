module Napa
  class Middleware
    class DatabaseStats
      def initialize(app)
        @app = app
      end

      def call(env)
        if defined?(ActiveRecord)
          ActiveSupport::Notifications.subscribe 'sql.active_record' do |name, start, finish, id, payload|
            if payload[:sql].match(/(select|update|insert|delete)(.+)/i)
              table, action = Napa::ActiveRecordStats.extract_sql_content(payload[:sql])
            end

            if table
              Napa::Stats.emitter.timing(
                "sql.query_time",
              (finish - start) * 1000)

              Napa::Stats.emitter.timing(
                "sql.table.#{table}.#{action.downcase}.query_time",
              (finish - start) * 1000)
            end
          end
        end

        status, headers, body = @app.call(env)
        [status, headers, body]
      end
    end
  end
end
