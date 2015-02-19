require 'spec_helper'
require 'napa/cli/base/new'

describe Napa::CLI::Base do
  let(:app_name) { 'my_test_app' }
  let(:app_path) { 'spec/my_different_directory' }
  let(:options) { {} }

  silence_thor

  before do
    scaffold = Napa::CLI::Base.new(args, options)
    scaffold.invoke(:new)
  end

  after do
    if args[1] # if app_path exists, delete dir at app_path
      FileUtils.rm_rf(args[1])
    else # otherwise delete dir at app_name
      FileUtils.rm_rf(args[0])
    end
  end

  context 'given only an app name' do
    let(:args) { [app_name] }

    it 'creates a scaffold app in a directory that mirrors the app name' do
      args = [app_name]
      expect(Dir).to exist(app_name)
    end
  end

  context 'given an app name and a directory' do
    let(:args) { [app_name, app_path] }

    it 'creates a scaffold app in a directory of my choosing' do
      expect(Dir).to exist(app_path)
    end

    it 'creates a .env file with with a development database name' do
      expect(File).to exist("#{app_path}/.env")
      env_file = File.read("#{app_path}/.env")
      expect(env_file).to match(/#{app_name}_development/)
    end

    it 'creates a .env.test file with a test database name' do
      expect(File).to exist("#{app_path}/.env.test")
      env_test_file = File.read("#{app_path}/.env.test")
      expect(env_test_file).to match(/#{app_name}_test/)
    end

    it 'selects mysql as the default database adapter' do
      database_config_file = File.read("#{app_path}/config/database.yml")
      expect(database_config_file).to match(/adapter: mysql2/)
    end

    it 'adds the mysql2 gem in the Gemfile' do
      gemfile = File.read("#{app_path}/Gemfile")
      expect(gemfile).to match(/gem 'mysql2'/)
    end

    it 'generates an application api' do
      expect(File).to exist("#{app_path}/app/apis/application_api.rb")
    end

    it 'the application API inherits from Grape::API' do
      application_api_file = File.read("#{app_path}/app/apis/application_api.rb")
      expect(application_api_file).to match(/class ApplicationApi < Grape::API/)
    end

    it 'generates an example API and spec' do
      expect(File).to exist("#{app_path}/app/apis/hello_api.rb")
      expect(File).to exist("#{app_path}/spec/apis/hello_api_spec.rb")
    end
  end

  context 'with the -d=pg option' do
    let(:args) { [app_name, app_path] }
    let(:options) { { :database => "pg" } }

    it 'selects postres/pg as the database' do
      database_config_file = File.read("#{app_path}/config/database.yml")
      expect(database_config_file).to match(/adapter: postgresql/)
    end

    it 'adds the pg gem in the Gemfile' do
      gemfile = File.read("#{app_path}/Gemfile")
      expect(gemfile).to match(/gem 'pg'/)
    end
  end
end
