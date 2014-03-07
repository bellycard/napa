module Napa
  class Identity
    def self.health
      {
        name: name,
        hostname: hostname,
        revision: revision,
        pid: pid,
        parent_pid: parent_pid,
        platform: platform
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

    def self.platform
      {
        version: platform_revision,
        name: platform_name
      }
    end

    def self.platform_name
      Napa.name
    end

    def self.platform_revision
      Napa::VERSION
    end
  end
end
