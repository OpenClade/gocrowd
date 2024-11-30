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

      response '202', 'Login successful' do
        let(:auth) { { email: 'user@example.com', password: 'password123' } }
        run_test! do |response|
          json = JSON.parse(response.body)
          expect(json['token']).to be_present
          expect(json['user']['email']).to eq('user@example.com')
        end
      end

      response '401', 'Incorrect password' do
        let(:auth) { { email: 'user@example.com', password: 'wrongpassword' } }
        run_test!
      end

      response '401', "User doesn't exist" do
        let(:auth) { { email: 'nonexistent@example.com', password: 'password123' } }
        run_test!
      end
    end
  end
end
