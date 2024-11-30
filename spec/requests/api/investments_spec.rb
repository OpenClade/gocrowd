# spec/integration/investments_spec.rb
require 'swagger_helper'

RSpec.describe 'Investments API', type: :request do
   

  # Для GET /api/v1/me/investments (Получить инвестиции текущего пользователя)
  path '/api/v1/investments' do
    get 'Возвращает все инвестиции текущего пользователя' do
      tags 'Investments'
      produces 'application/json'

      response '200', 'Investments found' do
        let(:investor) { create(:investor, user: current_user) }
        let(:investment) { create(:investment, investor: investor) }
        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json.first['investor_id']).to eq(investor.id)
        end
      end

      security [bearerAuth: []]

      response '404', 'Investor not found' do
        let(:investor) { nil }
        run_test!
      end
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

      response '201', 'Investment created' do
        let(:investment) { { offering_id: create(:offering).id, amount: 5000 } }
        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json['amount']).to eq(5000)
        end
      end

      security [bearerAuth: []]

      response '422', 'Invalid request' do
        let(:investment) { { offering_id: nil, amount: 5000 } }
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

      response '200', 'Bank statement uploaded' do
        let(:investment) { create(:investment) }
        let(:file) { Rack::Test::UploadedFile.new('spec/fixtures/bank_statement.pdf', 'application/pdf') }
        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json['investment']['bank_statement']).to be_present
        end
      end

      security [bearerAuth: []]

      response '422', 'Invalid file' do
        let(:investment) { create(:investment) }
        let(:file) { nil }
        run_test!
      end
    end
  end
  
end
