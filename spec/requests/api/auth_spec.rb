# spec/integration/auth_spec.rb
require 'swagger_helper'

RSpec.describe 'Auth API', type: :request do
  # Для POST /api/v1/login (Авторизация пользователя)
  path '/api/v1/auth/login' do
    post 'Авторизует пользователя и возвращает токен' do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :auth, in: :body, required: true, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          password: { type: :string, example: 'password123' }
        },
        required: ['email', 'password']
      }

      response '200', 'Login successful' do
        let(:auth) { { email: 'user@example.com', password: 'password123' } }
        
      end

      response '400', 'Incorrect email or password' do
        let(:auth) { { email: 'user@example.com', password: 'wrongpassword' } }
        run_test!
      end
    end
  end
end
