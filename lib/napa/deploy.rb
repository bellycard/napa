require 'git'
require 'octokit'

module Napa
  class Deploy
    attr_reader :errors, :github_login

    def initialize(environment, revision: nil, force: false, github_repo: nil, github_token: nil)
      Napa.load_environment

      @github_repo  = github_repo || ENV['GITHUB_REPO']
      @github_token = github_token || ENV['GITHUB_OAUTH_TOKEN']
      @environment  = environment
      @revision     = revision || local_head_revision
      @force        = force

      @errors       = []
    end

    def deploy!
      if deployable?
        set_github_tag
        "#{@revision} tagged as #{@environment} by #{@github_login} at #{Time.now.to_s(:long)}"
      else
        "Deploy error(s): #{@errors.join(' --- ')}"
      end
    end

    def set_github_tag
      begin
        github_client.update_ref(
          @github_repo,
          "tags/#{@environment}",
          @revision,
          @force
        )
      rescue Octokit::UnprocessableEntity
        github_client.create_ref(
          @github_repo,
          "tags/#{@environment}",
          @revision
        )
      end
    end

    def local_repo
      @local_repo ||= Git.open('.')
    end

    def local_repo_status
      @local_repo_status ||= local_repo.status
    end

    def github_client
      return @github_client if @github_client
      @errors << "ENV['GITHUB_REPO'] is not defined" if @github_repo.nil?
      @errors << "ENV['GITHUB_OAUTH_TOKEN'] is not defined" if @github_token.nil?

      client = Octokit::Client.new(access_token: @github_token)
      begin
        @github_login = client.login
        return @github_client = client
      rescue Octokit::Unauthorized
        @errors << "Access denied for GITHUB_OAUTH_TOKEN"
      end
    end

    def local_head_revision
      local_repo.object('HEAD').sha
    end

    def deployable?
      revision_exists_on_github?
      any_local_uncommited_changes?
      any_local_untracked_files?

      @errors.empty? || @force
    end

    def revision_exists_on_github?
      begin
        github_client.commit(@github_repo, @revision)
      rescue Octokit::NotFound
        @errors << "Revision #{@revision} does not exist on #{@github_repo}, make sure you've merged your changes."
      end
    end

    def any_local_uncommited_changes?
      changes = local_repo_status.changed.collect{|change| change[0]}
      @errors << "#{changes.to_sentence} have been changed and not committed." if changes.any?
    end

    def any_local_untracked_files?
      changes = local_repo_status.untracked.collect{|change| change[0]}
      @errors << "#{changes.to_sentence} file(s) have been added and are not tracked." if changes.any?
    end
  end
end
