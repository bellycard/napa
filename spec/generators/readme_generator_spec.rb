require 'spec_helper'
require 'napa/generators/readme_generator'
require 'napa/cli'

describe Napa::Generators::ReadmeGenerator do
  let(:test_readme_directory) { 'spec/tmp' }

  tell_me_mr_odinson_what_good_is_a_phone_call_if_youre_unable_to_speak?

  before do
    allow_any_instance_of(described_class).to receive(:output_directory).and_return(test_readme_directory)
    Napa::CLI::Base.new.generate("readme")
  end

  after do
    FileUtils.rm_rf(test_readme_directory)
  end

  describe 'README' do
    it 'creates a README in the current directory' do
      expected_readme_file = File.join(test_readme_directory, 'README.md')
      readme = File.read(expected_readme_file)

      expect(readme).to match /# #{Napa::Identity.name}/
    end
  end

  describe 'spec' do
    it 'creates a README spec' do
      expected_spec_file = File.join(test_readme_directory, 'spec/docs/readme_spec.rb')
      spec_code = File.read(expected_spec_file)

      expect(spec_code).to match(/describe \'README\'/)
    end
  end

end
