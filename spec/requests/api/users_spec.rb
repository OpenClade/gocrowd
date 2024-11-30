# spec/integration/users_spec.rb
require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  # Для POST /api/v1/users (Создание нового пользователя)
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
        let(:user) { { email: 'existing@example.com', password: 'password123'} }
        before do
          create(:user, email: 'existing@example.com', password: 'password123')
        end
        run_test!
      end

      response '422', 'Invalid request' do
        let(:user) { { email: '', password: 'password123'} }
        run_test!
      end
    end
  end

  # Для GET /api/v1/users/me (Получить информацию о текущем пользователе)
  path '/api/v1/users/me' do
    get 'Возвращает информацию о текущем пользователе' do
      tags 'Users'
      produces 'application/json'
      
      security [bearerAuth: []]  # Если используется аутентификация через токен
      
      response '200', 'User found' do
        let(:Authorization) { "Bearer #{generate_jwt_token(user_id: 1)}" }  # Генерация JWT токена для теста
        let(:user) { create(:user, id: 1, email: 'test@example.com') }

        before do
          user
        end
        
        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json['email']).to eq('test@example.com')
        end
      end
      
      security [bearerAuth: []]

      response '401', 'Unauthorized' do
        let(:Authorization) { "Bearer invalid_token" }
        run_test!
      end
    end
  end 
end
