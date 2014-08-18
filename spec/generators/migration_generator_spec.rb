require 'spec_helper'
require 'napa/generators/migration_generator'
require 'napa/cli'

describe Napa::Generators::MigrationGenerator do

  let(:migration_name) { 'foo_bars' }
  let(:test_migrations_directory) { 'spec/tmp' }

  before do
    # allow_any_instance_of(described_class).to receive(:output_directory).and_return(test_migrations_directory)
  end

  after do
    FileUtils.rm_rf(test_migrations_directory)
  end

  it 'creates a camelized migration class' do
    # allow_any_instance_of(described_class).to receive(:migration_filename).and_return('foo')
    # Napa::CLI::Base.new.generate("migration", migration_name)
    # expected_migration_file = File.join(test_migrations_directory, 'foo.rb')
    # migration_code = File.read(expected_migration_file)
    # expect(migration_code).to match(/class FooBars/)
  end


end
