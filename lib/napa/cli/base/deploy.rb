require 'napa/deploy'

module Napa
  module CLI
    class Base < Thor
      desc 'deploy [TARGET]', 'Deploys A Service to a given target (i.e. production, staging, etc.)'
      method_options force: :boolean, revision: :string, confirm: :boolean
      def deploy(environment)
        return unless options[:confirm] || yes?('Are you sure you want to deploy this service?', Thor::Shell::Color::YELLOW)
        deploy = Napa::Deploy.new(environment, force: options[:force], revision: options[:revision])
        if deploy.deployable?
          say(deploy.deploy!, Thor::Shell::Color::GREEN)
        else
          say("Deploy Failed:\n#{deploy.errors.join("\n")}", Thor::Shell::Color::RED)
        end
      end
    end
  end
end
