namespace :deploy do
  desc "Deploy to production"
  task :production do
    Rake::Task["git:verify"].invoke
    Rake::Task["git:set_tag"].invoke
  end

  desc "Deploy to staging"
  task :staging do
    Rake::Task["git:verify"].invoke
    Rake::Task["git:set_tag"].invoke("staging")
  end
end
