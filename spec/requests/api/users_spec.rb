require 'swagger_helper'

RSpec.describe 'Users API', type: :request do
  path '/users' do
    post 'Register a new user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'user@example.com' },
          password: { type: :string, example: 'password123' },
          role: { type: :string, example: 'user', default: 'user' }
        },
        required: %w[email password]
      }

      response '201', 'User created' do
        let(:user) { { email: 'newuser@example.com', password: 'password123', role: 'user' } }
        run_test!
      end

      response '422', 'Validation errors' do
        let(:user) { { email: '', password: '' } }
        run_test!
      end

      response '401', 'User already exists' do
        let!(:existing_user) { create(:user, email: 'user@example.com') }
        let(:user) { { email: 'user@example.com', password: 'password123' } }
        run_test!
      end
    end
  end

  path '/me' do
    get 'Get the current user' do
      tags 'Users'
      produces 'application/json'
      security [bearerAuth: []] # Используйте токен авторизации

      response '200', 'Current user retrieved' do
        let(:Authorization) { "Bearer #{JWT.encode({ user_id: create(:user).id }, Rails.application.secrets.secret_key_base)}" }
        run_test!
      end

      response '401', 'Unauthorized' do
        let(:Authorization) { nil }
        run_test!
      end
    end
  end
end
