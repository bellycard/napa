desc 'Run the RSpec test suite'
task :spec do
  sh *%w[
    bundle exec
      rspec --colour
            --format documentation
            --fail-fast
  ]
end
