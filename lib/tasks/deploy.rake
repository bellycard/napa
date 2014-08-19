namespace :deploy do
  desc "Deploy to production"
  task :production do
    puts "\033[31mrake deploy:production is deprecated, please use 'napa deploy production'\033[0m"
  end

  desc "Deploy to staging"
  task :staging do
    puts "\033[31mrake deploy:staging is deprecated, please use 'napa deploy staging'\033[0m"
  end
end
