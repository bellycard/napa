desc "bump the gem version"
namespace :version do
  namespace :bump do

    task :major do
      @new_version = Napa::Version.next_major
      execute_version_bump
    end

    task :minor do
      @new_version = Napa::Version.next_minor
      execute_version_bump
    end

    task :patch do
      @new_version = Napa::Version.next_patch
      execute_version_bump
    end

    def execute_version_bump
      if !clean_staging_area?
        system "git status"
        raise "Unclean staging area! Be sure to commit or .gitignore everything first. See `git status` above."
      else
        require 'git'
        git = Git.open('.')

        write_update
        git.add('lib/napa/version.rb')
        git.commit("Version bump: #{release_tag}")
        git.add_tag(release_tag)
        git.push(git.remote('origin'), git.branch, release_tag) if git.remote('origin')
        puts "Version bumped: #{release_tag}"
      end
    end

    def write_update
      filedata = File.read('lib/napa/version.rb')
      changed_filedata = filedata.gsub("VERSION = \"#{Napa::VERSION}\"\n", "VERSION = \"#{@new_version}\"\n")
      File.open('lib/napa/version.rb',"w"){|file| file.write changed_filedata}
    end

    def clean_staging_area?
      `git ls-files --deleted --modified --others --exclude-standard` == ""
    end

    def release_tag
      "v#{@new_version}"
    end
  end
end