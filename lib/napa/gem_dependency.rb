module Napa
  class GemDependency
    def self.log_all
      Napa::Logger.logger.info(gems: list_all.as_json)
    end

    def self.list_all
      Gem.loaded_specs.map { |spec| new(spec).to_hash }
    end

    def initialize(spec)
      @spec = spec[1]
    end

    def name
      @spec.name
    end

    def version
      @spec.version.to_s
    end

    def git_version
      @spec.git_version
    end

    def to_hash
      {}.tap do |h|
        h[:name] = name
        h[:version] = version
        h[:git_version] = git_version if git_version
      end
    end
  end
end
