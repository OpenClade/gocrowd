# spec/integration/users_spec.rb
require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/api/v1/users' do
    post 'Создает нового пользователя' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, required: true, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
          role: { type: :string }
        },
        required: ['email', 'password', 'role']
      }

      response '201', 'User created' do
        let(:user) { { email: 'test@example.com', password: 'password123'} }
        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json['user']['email']).to eq('test@example.com')
        end
      end

      response '401', 'User already exists' do
        let!(:existing_user) { FactoryBot.create(:user, email: 'existing@example.com') }
        let(:user) { { email: 'existing@example.com', password: 'password123'} }         
        run_test!
      end

      response '400', 'Invalid request' do
        let(:user) { { email: '', password: 'password123'} }
        run_test!
      end
    end
  end

  path '/api/v1/users/me' do
    get 'Возвращает информацию о текущем пользователе' do
      tags 'Users'
      produces 'application/json'
      
      security [bearerAuth: []]
      
      let(:user) { FactoryBot.create(:user) }
      let(:Authorization) { "Bearer #{generate_jwt_token(user_id: user.id)}" }
      response '200', 'User found' do
        run_test! 
      end
    end
  end 
end
