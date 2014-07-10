namespace :git do
  client = Octokit::Client.new(:access_token => ENV['GITHUB_OAUTH_TOKEN'])
  logger = Logger.new(STDOUT)

  github_repo = ENV['GITHUB_REPO']
  local_sha = `git rev-parse HEAD`.strip

  desc "Verify git repository is in a good state for deployment"
  task :verify do
    raise RuntimeError, "ENV['GITHUB_REPO'] is not defined" if github_repo.nil?
    raise RuntimeError, "ENV['GITHUB_OAUTH_TOKEN'] is not defined" if ENV['GITHUB_OAUTH_TOKEN'].nil?

    logger.info "Verifying git repository is in a good state"

    # Be sure local HEAD exists on remote
    begin
      remote_commit = client.commit(github_repo, local_sha)
    rescue Octokit::NotFound
      raise RuntimeError, "Local commit #{local_sha} does not exist on remote. Be sure to push your changes."
    end

    # Check for uncommited changes
    unless(system("git diff --quiet HEAD"))
      raise RuntimeError, "You have uncommited changes. Either commit or stash them before continuing."
    end

    # Check for untracked files
    unless(`git status --porcelain | grep '^??' | wc -l`.strip == "0")
      raise RuntimeError, "You have untracked files. Either commit or remove them before continuing."
    end
  end

  desc "Set tag, which triggers deploy"
  task :set_tag, :tag do |t, args|
    tag = args[:tag] || "production"
    logger.info "Setting #{tag} tag on github"

    # Update ref, create ref if it doesn't exist
    begin
      client.update_ref(
        github_repo,
        "tags/#{tag}",
        local_sha
      )
    rescue Octokit::UnprocessableEntity
      client.create_ref(
        github_repo,
        "tags/#{tag}",
        local_sha
      )
    end
  end
end
