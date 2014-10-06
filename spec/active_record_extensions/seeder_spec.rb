require 'active_record'
require 'spec_helper'
require 'napa/active_record_extensions/seeder'

describe Napa::ActiveRecordSeeder do

  context 'when a valid file is not provided' do
    it 'raises an exception' do
    	expect{Napa::ActiveRecordSeeder.load_file 'not-a-file'}.to raise_error
    end
  end

end
