require 'spec_helper'
require 'rack/test'

describe Napa::GrapeExtenders do
  include Rack::Test::Methods

  before do
    allow(Napa::Logger.logger).to receive(:debug)
  end

  subject do
    Class.new(Grape::API) do
      format :json
      extend Napa::GrapeExtenders
    end
  end

  def app
    subject
  end

  describe 'ActiveRecord extensions' do
    it 'rescues ActiveRecord::RecordNotFound and returns a 404' do
      subject.get do
        raise ActiveRecord::RecordNotFound
      end

      get '/'
      expect(response_code).to be 404
      expect(parsed_response.error.code).to eq 'record_not_found'
    end
  end

  describe 'AASM extensions' do
    it 'rescues AASM::InvalidTransition and returns a 422' do
      module AASM
        class InvalidTransition < StandardError
        end
      end

      subject.get do
        raise AASM::InvalidTransition
      end

      get '/'
      expect(response_code).to be 422
      expect(parsed_response.error.code).to eq 'unprocessable_entity'
    end
  end
end