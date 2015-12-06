require 'spec_helper'
require 'napa/cli/migration'

describe Napa::CLI::Migration do

  let(:migration_filename) { 'foo' }
  let(:test_migrations_directory) { 'spec/tmp' }

  silence_thor

  before do
    allow_any_instance_of(described_class).to receive(:output_directory).and_return(test_migrations_directory)
    allow_any_instance_of(described_class).to receive(:migration_filename).and_return(migration_filename)
  end

  after do
    FileUtils.rm_rf(test_migrations_directory)
  end

  describe 'AddFooToBar flew:string:index brew:integer' do
    before do
      Napa::CLI::Migration.new(['AddFooToBar', 'flew:string:index', 'brew:integer']).invoke_all

      expected_migration_file = File.join(test_migrations_directory, 'foo.rb')
      @migration_code = File.read(expected_migration_file)
    end

    it 'creates a camelized migration class' do
      expect(@migration_code).to match(/class AddFooToBar/)
    end

    it 'adds the columns' do
      expect(@migration_code).to match(/add_column :bars, :flew, :string/)
      expect(@migration_code).to match(/add_column :bars, :brew, :integer/)
    end

    it 'adds the index on the correct column' do
      expect(@migration_code).to match(/add_index :bars, :flew/)
    end
  end

  describe 'RemoveFooFromBar flew:string brew:integer' do
    before do
      Napa::CLI::Migration.new(['RemoveFooFromBar', 'flew:string', 'brew:integer']).invoke_all
      expected_migration_file = File.join(test_migrations_directory, 'foo.rb')
      @migration_code = File.read(expected_migration_file)
    end

    it 'creates a camelized migration class' do
      expect(@migration_code).to match(/class RemoveFooFromBar/)
    end

    it 'removes the columns' do
      expect(@migration_code).to match(/remove_column :bars, :flew, :string/)
      expect(@migration_code).to match(/remove_column :bars, :brew, :integer/)
    end
  end

  describe 'CreateJoinTableFooBar foo bar' do
    before do
      Napa::CLI::Migration.new(%w(CreateJoinTableFooBar foo bar)).invoke_all
      expected_migration_file = File.join(test_migrations_directory, 'foo.rb')
      @migration_code = File.read(expected_migration_file)
    end

    it 'creates a camelized migration class' do
      expect(@migration_code).to match(/class CreateJoinTableFooBar/)
    end

    it 'creates the join table' do
      expect(@migration_code).to match(/create_join_table :foos, :bars/)
    end

    it 'adds placeholders for the indexing' do
      expect(@migration_code).to match(/# t.index \[:foo_id, :bar_id\]/)
      expect(@migration_code).to match(/# t.index \[:bar_id, :foo_id\]/)
    end
  end

  describe 'CreateSkrillex drops:integer hair:string:index' do
    before do
      Napa::CLI::Migration.new(['CreateSkrillex', 'drops:integer', 'hair:string:index']).invoke_all
      expected_migration_file = File.join(test_migrations_directory, 'foo.rb')
      @migration_code = File.read(expected_migration_file)
    end

    it 'creates a camelized migration class' do
      expect(@migration_code).to match(/class CreateSkrillex/)
    end

    it 'creates the table' do
      expect(@migration_code).to match(/create_table :skrillexes/)
    end

    it 'adds the columns' do
      expect(@migration_code).to match(/t.integer :drops/)
      expect(@migration_code).to match(/t.string :hair/)
    end

    it 'adds the index on the correct column' do
      expect(@migration_code).to match(/add_index :skrillexes, :hair/)
    end
  end

end
