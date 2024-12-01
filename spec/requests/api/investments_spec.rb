# spec/integration/investments_spec.rb
require 'swagger_helper'

RSpec.describe 'Investments API', type: :request do
   

  # Для GET /api/v1/me/investments (Получить инвестиции текущего пользователя)
  path '/api/v1/investments' do
    get 'Возвращает все инвестиции текущего пользователя' do
      tags 'Investments'
      produces 'application/json'

      let(:user) { FactoryBot.create(:user) }
      let(:investor) { FactoryBot.create(:investor, user: user) }
      let(:Authorization) { "Bearer #{generate_jwt_token(user_id: user.id)}" } 
      let!(:investments) { FactoryBot.create_list(:investment, 5, investor: investor) }

      response '200', 'Investments found' do 

        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json).to be_an_instance_of(Array)
          expect(json.size).to eq(5)
        end
      end
      security [bearerAuth: []]

       
    end
  end

  # Для POST /api/v1/investments (Создание новой инвестиции)
  path '/api/v1/investments' do
    post 'Создает новую инвестицию' do
      tags 'Investments'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :investment, in: :body, required: true, schema: {
        type: :object,
        properties: {
          offering_id: { type: :integer },
          amount: { type: :number }
        },
        required: ['offering_id', 'amount']
      }

      security [bearerAuth: []] 
      let(:user) { FactoryBot.create(:user) }
      let(:Authorization) { "Bearer #{generate_jwt_token(user_id: user.id)}" }
 
      response '201', 'Investment created' do 
         
        let(:investor) { FactoryBot.create(:investor, user: user) }
        let(:offering) { FactoryBot.create(:offering) }
        let(:investment) { FactoryBot.create(:investment, investor: investor, offering: offering, amount: 1000) }
        run_test!  
      end
      
      response '400', 'Invalid request' do
        let(:investment) { { amount: 0 } }
        run_test!
      end
    end
  end

   

  # Для POST /api/v1/investments/:id/upload_bank_statement (Загрузка банковской выписки)
  path '/api/v1/investments/{id}/upload_bank_statement' do
    post 'Загружает банковскую выписку для инвестиции' do
      tags 'Investments'
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: :id, in: :path, type: :string, description: 'Investment ID'
      parameter name: :file, in: :formData, type: :file, description: 'Bank Statement'

      let(:user) { FactoryBot.create(:user) }
      let(:investor) { FactoryBot.create(:investor, user: user) }
      let(:offering) { FactoryBot.create(:offering) }
      let(:investment) { FactoryBot.create(:investment, investor: investor, offering: offering, amount: 1000) }
      
      let(:id) { investment.id }  # Define the investment ID
      let(:Authorization) { "Bearer #{generate_jwt_token(user_id: user.id)}" }

      response '200', 'Bank statement uploaded' do 
        let(:file) { fixture_file_upload('./bank_statement.pdf', 'application/pdf') }
        run_test!  
      end

      security [bearerAuth: []]

      response '422', 'Invalid file' do
        let(:file) { nil }
        run_test!
      end
    end
  end
  
end
