# spec/requests/investments_spec.rb
require 'swagger_helper'

RSpec.describe 'Investments API', type: :request do
  path '/investments' do
    get 'Retrieves all investments' do
      tags 'Investments'
      produces 'application/json'
      parameter name: :toffset, in: :query, type: :integer, description: 'Offset for pagination'
      parameter name: :tlimit, in: :query, type: :integer, description: 'Limit for pagination'
      parameter name: :tid_sort, in: :query, type: :string, description: 'Sort order (asc or desc)'

      response '200', 'investments found' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   investor_id: { type: :integer },
                   offering_id: { type: :integer },
                   amount: { type: :number },
                   status: { type: :string },
                   created_at: { type: :string, format: 'date-time' },
                   updated_at: { type: :string, format: 'date-time' }
                 },
                 required: %w[id investor_id offering_id amount status created_at updated_at]
               }

        let(:toffset) { 0 }
        let(:tlimit) { 10 }
        let(:tid_sort) { 'asc' }
        run_test!
      end
    end
  end

  path '/investments/{id}' do
    get 'Retrieves a specific investment' do
      tags 'Investments'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'ID of the investment'

      response '200', 'investment found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 investor_id: { type: :integer },
                 offering_id: { type: :integer },
                 amount: { type: :number },
                 status: { type: :string },
                 created_at: { type: :string, format: 'date-time' },
                 updated_at: { type: :string, format: 'date-time' }
               },
               required: %w[id investor_id offering_id amount status created_at updated_at]

        let(:id) { Investment.create!(investor: Investor.first, offering: Offering.first, amount: 100, status: 'pending').id }
        run_test!
      end

      response '404', 'investment not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end

  path '/investments' do
    post 'Creates an investment' do
      tags 'Investments'
      consumes 'application/json'
      parameter name: :investment, in: :body, schema: {
        type: :object,
        properties: {
          offering_id: { type: :integer },
          amount: { type: :number },
          status: { type: :string }
        },
        required: %w[offering_id amount status]
      }

      response '201', 'investment created' do
        let(:investment) { { offering_id: Offering.first.id, amount: 100, status: 'pending' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:investment) { { amount: 100 } }
        run_test!
      end
    end
  end

  path '/investments/{id}' do
    patch 'Updates an investment' do
      tags 'Investments'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'ID of the investment'
      parameter name: :investment, in: :body, schema: {
        type: :object,
        properties: {
          amount: { type: :number },
          status: { type: :string }
        },
        required: %w[amount status]
      }

      response '200', 'investment updated' do
        let(:id) { Investment.create!(investor: Investor.first, offering: Offering.first, amount: 100, status: 'pending').id }
        let(:investment) { { amount: 200, status: 'confirmed' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { Investment.create!(investor: Investor.first, offering: Offering.first, amount: 100, status: 'pending').id }
        let(:investment) { { amount: nil } }
        run_test!
      end
    end
  end
end