require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'POST #create' do
    context 'when the user does not exist' do
      let(:user_params) { { email: 'test@example.com', password: 'password123' } }

      it 'creates a new user' do
        expect {
          post :create, params: user_params
        }.to change(User, :count).by(1)
      end

      it 'returns the created user and a token' do
        post :create, params: user_params
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(json_response['user']['email']).to eq('test@example.com')
        expect(json_response['token']).not_to be_nil
      end

      it 'sends a registration email' do
        allow(MailSender).to receive(:send_register_email).and_call_original

        post :create, params: user_params

        expect(MailSender).to have_received(:send_register_email).once
      end
    end

    context 'when the user already exists' do
      let!(:existing_user) { create(:user, email: 'test@example.com', password: 'password123') }
      let(:user_params) { { email: 'test@example.com', password: 'password123' } }

      it 'returns an unauthorized status' do
        post :create, params: user_params
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unauthorized)
        expect(json_response['message']).to eq('User already exists')
      end
    end

    context 'when user params are invalid' do
      let(:invalid_user_params) { { email: 'invalidemail', password: '123' } }

      it 'returns an unprocessable entity status with error messages' do
        post :create, params: invalid_user_params
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include("Email is invalid", "Password is too short (minimum is 6 characters)")
      end
    end
  end
end
