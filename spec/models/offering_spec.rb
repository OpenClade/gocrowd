require 'rails_helper'

RSpec.describe Api::V1::OfferingsController, type: :controller do
  let(:user) { create(:user) }  # Assumes you have a User factory
  let(:offering) { create(:offering) }  # Assumes you have an Offering factory

  before do
    sign_in(user)  # Assumes you are using Devise or a similar authentication method
  end

  describe 'GET #index' do
    context 'when there are offerings' do
      before do
        create_list(:offering, 5)  # Assumes you have an Offering factory
      end

      it 'returns a list of offerings' do
        get :index

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json_response.length).to eq(5)  # Should return 5 offerings
      end

      it 'returns offerings sorted by id in ascending order' do
        get :index, params: { sort: 'asc' }
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_response.first['id']).to be < json_response.last['id']  # Should be sorted in ascending order
      end

      it 'returns offerings with pagination when requested' do
        get :index, params: { page: 1, per_page: 2 }

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json_response.length).to eq(2)  # Should return only 2 offerings
      end
    end

    context 'when there are no offerings' do
      it 'returns an empty array' do
        get :index

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json_response).to eq([])  # Should return an empty array if no offerings exist
      end
    end
  end

  describe 'GET #show' do
    it 'returns the requested offering' do
      get :show, params: { id: offering.id }

      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json_response['id']).to eq(offering.id)
    end

    it 'returns an error if the offering does not exist' do
      get :show, params: { id: 'nonexistent' }

      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:not_found)
      expect(json_response['error']).to eq('Offering not found')
    end
  end

  describe 'PUT #update' do
    context 'when the offering exists and is updated successfully' do
      it 'updates the offering' do
        updated_params = { name: 'Updated Offering', status: 'approved' }

        put :update, params: { id: offering.id, offering: updated_params }

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json_response['name']).to eq('Updated Offering')
        expect(json_response['status']).to eq('approved')
      end
    end

    context 'when the offering exists but cannot be updated' do
      it 'returns errors when validation fails' do
        put :update, params: { id: offering.id, offering: { name: nil } }  # Assuming 'name' is required

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['name']).to include("can't be blank")
      end
    end

    context 'when the offering does not exist' do
      it 'returns an error' do
        put :update, params: { id: 'nonexistent', offering: { name: 'Updated Offering' } }

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json_response['error']).to eq('Offering not found')
      end
    end
  end
end
