# spec/integration/investors_spec.rb
require 'swagger_helper'

RSpec.describe 'Investors API', type: :request do
  path '/investors/{id}' do
    get 'Retrieve an investor' do
      tags 'Investors'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Investor ID'

      response '200', 'Investor found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 kyc_status: { type: :string },
                 kyc_verified_at: { type: :string, format: :datetime },
                 user_id: { type: :integer }
               },
               required: %w[id kyc_status user_id]

        let(:id) { Investor.create(user: create(:user)).id }
        run_test!
      end

      response '404', 'Investor not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/investors' do
    post 'Create an investor' do
      tags 'Investors'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :investor, in: :body, schema: {
        type: :object,
        properties: {
          kyc_status: { type: :string },
          kyc_verified_at: { type: :string, format: :datetime }
        },
        required: %w[kyc_status]
      }

      response '201', 'Investor created' do
        let(:investor) { { kyc_status: 'pending', kyc_verified_at: nil } }
        run_test!
      end

      response '422', 'Invalid request' do
        let(:investor) { { kyc_status: nil } }
        run_test!
      end
    end
  end

  path '/investors/{id}' do
    put 'Update an investor' do
      tags 'Investors'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'Investor ID'
      parameter name: :investor, in: :body, schema: {
        type: :object,
        properties: {
          kyc_status: { type: :string },
          kyc_verified_at: { type: :string, format: :datetime }
        }
      }

      response '200', 'Investor updated' do
        let(:id) { Investor.create(user: create(:user)).id }
        let(:investor) { { kyc_status: 'approved' } }
        run_test!
      end

      response '404', 'Investor not found' do
        let(:id) { 'invalid' }
        let(:investor) { { kyc_status: 'approved' } }
        run_test!
      end
    end
  end
end
