module Napa
  class Identity
    def self.health
      {
        name: name,
        hostname: hostname,
        revision: revision,
        pid: pid,
        parent_pid: parent_pid,
        napa_revision: napa_revision
      }
    end

    def self.name
      ENV['SERVICE_NAME'] || 'api-service'
    end

    def self.hostname
      @hostname ||= `hostname`.strip
    end

    def self.revision
      @revision ||= `git rev-parse HEAD`.strip
    end

    def self.pid
      @pid ||= Process.pid
    end

    def self.parent_pid
      @ppid ||= Process.ppid
    end

    def self.napa_revision
      Napa::VERSION
    end
  end
end
