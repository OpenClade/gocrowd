# spec/integration/investors_spec.rb
require 'swagger_helper'

RSpec.describe 'Investors API', type: :request do
   

  # Для GET /api/v1/me/investor (Получить информацию о текущем инвесторе)
  path '/api/v1/investors/me' do
    get 'Возвращает информацию о текущем инвесторе' do
      tags 'Investors'
      produces 'application/json'

      response '200', 'Investor found' do
        let(:investor) { create(:investor, user: current_user) }
        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json['user_id']).to eq(current_user.id)
        end
      end
      
      security [bearerAuth: []]
      response '404', 'Investor not found' do
        let(:investor) { nil }
        run_test!
      end
    end
  end

  # Для POST /api/v1/investors (Создать нового инвестора)
  path '/api/v1/investors' do
    post 'Создает нового инвестора' do
      tags 'Investors'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :investor, in: :body, required: true, schema: {
        type: :object,
        properties: {
          kyc_verified_at: { type: :string, format: 'date-time' },
        },
        required: ['kyc_verified_at']
      }

      response '201', 'Investor created' do
        let(:investor) { { kyc_verified_at: '2024-11-30T00:00:00Z' } }
        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json['kyc_status']).to eq('pending')
        end
      end
      
      security [bearerAuth: []]
      response '422', 'Invalid request' do
        let(:investor) { { kyc_verified_at: '' } }
        run_test!
      end
    end
  end 
end
