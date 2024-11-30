require 'rails_helper'

RSpec.describe Api::V1::InvestorsController, type: :controller do
  let(:user) { create(:user) }  # Assumes a factory for User exists
  let(:investor) { create(:investor, user: user) }  # Assumes a factory for Investor exists

  before do
    sign_in(user)  # If using Devise for authentication
  end

  describe 'GET #show' do
    context 'when the investor exists' do
      it 'returns the investor' do
        get :show, params: { id: investor.id }
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_response['id']).to eq(investor.id)
        expect(json_response['kyc_status']).to eq(investor.kyc_status)
      end
    end

    context 'when the investor does not exist' do
      it 'returns a 404 error' do
        get :show, params: { id: 'nonexistent' }

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Investor not found')
      end
    end
  end

  describe 'GET #me' do
    context 'when the investor exists' do
      it 'returns the current user\'s investor' do
        get :me

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json_response['id']).to eq(investor.id)
      end
    end

    context 'when the investor does not exist' do
      before { investor.destroy }  # Simulating the scenario where the investor does not exist

      it 'returns a not found error' do
        get :me

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json_response['error']).to eq('Investor not found')
      end
    end
  end

  describe 'POST #create' do
    context 'when the investor does not exist for the current user' do
      it 'creates a new investor' do
        expect {
          post :create, params: { investor: { kyc_verified_at: Time.now } }
        }.to change(Investor, :count).by(1)

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:created)
        expect(json_response['kyc_status']).to eq('pending')
      end
    end

    context 'when the investor already exists for the current user' do
      it 'returns an error' do
        post :create, params: { investor: { kyc_verified_at: Time.now } }

        # Try to create the investor again for the same user
        post :create, params: { investor: { kyc_verified_at: Time.now } }
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to eq('Investor already exists')
      end
    end
  end

  describe 'PATCH/PUT #update' do
    context 'when the investor is successfully updated' do
      it 'updates the investor\'s kyc_verified_at attribute' do
        put :update, params: { id: investor.id, investor: { kyc_verified_at: Time.now } }
        
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json_response['kyc_verified_at']).not_to be_nil
      end
    end

    context 'when the update fails' do
      it 'returns an error message' do
        put :update, params: { id: investor.id, investor: { kyc_verified_at: nil } }
        
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['kyc_verified_at']).to include("can't be blank")
      end
    end
  end
end
