# spec/integration/investors_spec.rb
require 'swagger_helper'

RSpec.describe 'Investors API', type: :request do
   

  # Для GET /api/v1/me/investor (Получить информацию о текущем инвесторе)
  path '/api/v1/investors/me' do
    get 'Возвращает информацию о текущем инвесторе' do
      tags 'Investors'
      produces 'application/json'
  
      let(:user) { FactoryBot.create(:user) }
       
      let(:Authorization) { "Bearer #{generate_jwt_token(user_id: user.id)}" }

      response '200', 'Investor found' do
        let(:investor) { FactoryBot.create(:investor, user: user) }
        let!(:investments) { FactoryBot.create(:investment, investor: investor) }
        run_test! 
      end
  
      security [bearerAuth: []]

      # Invalid response case (no investor linked to the user)
      response '404', 'Investor not found' do  
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

      security [bearerAuth: []]


      let(:user) { FactoryBot.create(:user) }
      let(:Authorization) { "Bearer #{generate_jwt_token(user_id: user.id)}" }

      response '201', 'Investor created' do
        let(:investor) { { kyc_verified_at: '2024-11-30T00:00:00Z' } }
        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json['kyc_status']).to eq('pending')
        end
      end
      
       
       
    end
  end 
end
