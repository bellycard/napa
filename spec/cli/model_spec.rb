require 'spec_helper'
require 'napa/cli/model'

describe Napa::CLI::Model do
  let(:test_output_directory) { 'spec/tmp' }
  let(:version) { '20000101000000' }

  silence_thor

  before do
    allow_any_instance_of(described_class).to receive(:model_output_directory).and_return(test_output_directory)
    allow_any_instance_of(described_class).to receive(:migration_output_directory).and_return(test_output_directory)
    allow_any_instance_of(described_class).to receive(:factory_output_directory).and_return(test_output_directory)
    allow_any_instance_of(described_class).to receive(:model_spec_output_directory).and_return(test_output_directory)
    allow_any_instance_of(described_class).to receive(:version).and_return(version)
  end

  after do
    FileUtils.rm_rf(test_output_directory)
  end

  describe 'Car model' do
    before do
      model = Napa::CLI::Model.new([ 'Car',
                                     'transmission_type:references',
                                     'has_navigation:boolean' ],
                                   [ '--parent=Vehicle' ])
      model.invoke_all

      # The migration should not be created because a parent model is specified.
      @migration_file = File.join(test_output_directory, "#{version}_create_cars.rb")

      expected_model_file = File.join(test_output_directory, 'car.rb')
      @model_content = File.read(expected_model_file)

      expected_model_spec_file = File.join(test_output_directory, 'car_spec.rb')
      @model_spec_content = File.read(expected_model_spec_file)

      expected_factory_file = File.join(test_output_directory, 'cars.rb')
      @factory_content = File.read(expected_factory_file)
    end

    describe 'migration' do
      it 'is not created' do
        expect(File.exists?(@migration_file)).to eq(false)
      end
    end

    describe 'model' do
      it 'creates a model class' do
        expect(@model_content).to match(/class Car/)
      end

      it 'model inherits from ActiveRecord::Base' do
        expect(@model_content).to match(/Car < Vehicle/)
      end

      it 'adds belongs_to association for references attributes' do
        expect(@model_content).to match(/belongs_to :transmission_type/)
      end
    end

    describe 'model spec' do
      it 'loads the spec_helper' do
        expect(@model_spec_content).to match(/require 'spec_helper'/)
      end

      it 'describes the model' do
        expect(@model_spec_content).to match(/describe Car/)
      end

      it 'tests the creation of an model instance' do
        expect(@model_spec_content).to match(/car = create :car/)
      end

      it 'creates a pending test' do
        expect(@model_spec_content).to match(/pending\('.*'\)/)
      end
    end

    describe 'factory' do
      it 'creates a factory for the model' do
        expect(@factory_content).to match(/factory :car/)
      end

      it 'creates a stub for each attribute' do
        expect(@factory_content).to match(/association :transmission_type/)
        expect(@factory_content).to match(/has_navigation false/)
      end
    end

    after do
      FileUtils.rm_rf(test_output_directory)
    end
  end

  describe 'User model' do
    before do
      Napa::CLI::Model.new([ 'User',
                             'username:string:index',
                             'password:digest',
                             'referrer:references',
                             'birth_date:date:index' ]).invoke_all

      expected_migration_file = File.join(test_output_directory, "#{version}_create_users.rb")
      @migration_content = File.read(expected_migration_file)

      expected_model_file = File.join(test_output_directory, 'user.rb')
      @model_content = File.read(expected_model_file)

      expected_model_spec_file = File.join(test_output_directory, 'user_spec.rb')
      @model_spec_content = File.read(expected_model_spec_file)

      expected_factory_file = File.join(test_output_directory, 'users.rb')
      @factory_content = File.read(expected_factory_file)
    end

    describe 'migration' do
      it 'creates a creates a camelized migration class' do
        expect(@migration_content).to match(/class CreateUsers/)
      end

      it 'creates a table for the new model' do
        expect(@migration_content).to match(/create_table :users/)
      end

      it 'adds the specified columns' do
        expect(@migration_content).to match(/t.string :username/)
      end

      it 'adds the specified associations' do
        expect(@migration_content).to match(/t.references :referrer/)
      end

      it 'adds password digest column' do
        expect(@migration_content).to match(/t.string :password_digest/)
      end

      it 'adds the necessary indexes' do
        expect(@migration_content).to match(/add_index :users, :username/)
        expect(@migration_content).to match(/:referrer, index: true/)
        expect(@migration_content).to match(/add_index :users, :birth_date/)
      end
    end

    describe 'model' do
      it 'creates a model class' do
        expect(@model_content).to match(/class User/)
      end

      it 'model inherits from ActiveRecord::Base' do
        expect(@model_content).to match(/User < ActiveRecord::Base/)
      end

      it 'adds has_secure_password for password digest attributes' do
        expect(@model_content).to match(/has_secure_password/)
      end
    end

    describe 'model spec' do
      it 'loads the spec_helper' do
        expect(@model_spec_content).to match(/require 'spec_helper'/)
      end

      it 'describes the model' do
        expect(@model_spec_content).to match(/describe User/)
      end

      it 'tests the creation of an model instance' do
        expect(@model_spec_content).to match(/user = create :user/)
      end

      it 'creates a pending test' do
        expect(@model_spec_content).to match(/pending\('.*'\)/)
      end
    end

    describe 'factory' do
      it 'creates a factory for the model' do
        expect(@factory_content).to match(/factory :user/)
      end

      it 'creates a stub for each attribute' do
        expect(@factory_content).to match(/username "MyString"/)
        expect(@factory_content).to match(/password "password"/)
        expect(@factory_content).to match(/association :referrer/)
        expect(@factory_content).to match(/birth_date { Date.today }/)
      end

      it 'creates a confirmation for password attributes' do
        expect(@factory_content).to match(/password_confirmation "password"/)
      end
    end

    after do
      FileUtils.rm_rf(test_output_directory)
    end
  end

  describe 'Gender model' do
    before do
      model = Napa::CLI::Model.new([ 'Gender',
                                     'name:string',
                                     'personal_characteristic:belongs_to{polymorphic}' ],
                                   [ '--no-timestamps' ])
      model.invoke_all

      expected_migration_file = File.join(test_output_directory, "#{version}_create_genders.rb")
      @migration_content = File.read(expected_migration_file)

      expected_model_file = File.join(test_output_directory, 'gender.rb')
      @model_content = File.read(expected_model_file)

      expected_model_spec_file = File.join(test_output_directory, 'gender_spec.rb')
      @model_spec_content = File.read(expected_model_spec_file)

      expected_factory_file = File.join(test_output_directory, 'genders.rb')
      @factory_content = File.read(expected_factory_file)
    end

    describe 'migration' do
      it 'creates a migration class' do
        expect(@migration_content).to match(/class CreateGenders/)
      end

      it 'creates a table for the new model' do
        expect(@migration_content).to match(/create_table :genders/)
      end

      it 'adds the specified columns' do
        expect(@migration_content).to match(/t.string :name/)
      end

      it 'adds the specified associations' do
        expect(@migration_content).to match(/t.belongs_to :personal_characteristic/)
      end

      it 'sets up the polymorphic associations' do
        expect(@migration_content).to match(/:personal_characteristic, polymorphic: true/)
      end

      it 'does NOT add timestamps to the table' do
        expect(@migration_content).to_not match(/t.timestamps/)
      end
    end

    describe 'model' do
      it 'creates a model class' do
        expect(@model_content).to match(/class Gender/)
      end

      it 'model inherits from ActiveRecord::Base' do
        expect(@model_content).to match(/Gender < ActiveRecord::Base/)
      end

      it 'adds belongs_to associations' do
        expect(@model_content).to match(/belongs_to :personal_characteristic/)
      end

      it 'sets up polymorphic associations' do
        expect(@model_content).to match(/:personal_characteristic, polymorphic: true/)
      end
    end

    describe 'model spec' do
      it 'loads the spec_helper' do
        expect(@model_spec_content).to match(/require 'spec_helper'/)
      end

      it 'describes the model' do
        expect(@model_spec_content).to match(/describe Gender/)
      end

      it 'tests the creation of an model instance' do
        expect(@model_spec_content).to match(/gender = create :gender/)
      end

      it 'creates a pending test' do
        expect(@model_spec_content).to match(/pending\('.*'\)/)
      end
    end

    describe 'factory' do
      it 'creates a factory for the model' do
        expect(@factory_content).to match(/factory :gender/)
      end

      it 'creates a stub for each attribute' do
        expect(@factory_content).to match(/name "MyString"/)
      end
    end

    after do
      FileUtils.rm_rf(test_output_directory)
    end
  end
end
