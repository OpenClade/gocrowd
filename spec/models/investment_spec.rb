require 'rails_helper'

RSpec.describe Api::V1::InvestmentsController, type: :controller do
  let(:user) { create(:user) }  # Assumes you have a User factory
  let(:investor) { create(:investor, user: user) }  # Assumes you have an Investor factory
  let(:offering) { create(:offering) }  # Assumes you have an Offering factory
  let(:investment) { create(:investment, investor: investor, offering: offering, status: 'pending') }  # Assumes you have an Investment factory

  before do
    sign_in(user)  # Assumes you are using Devise or a similar authentication method
  end

  describe 'GET #index' do
    context 'when the investor is found' do
      it 'returns the investments for the current investor' do
        get :index

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json_response).to be_an_instance_of(Array)  # Should return an array of investments
      end

      it 'returns investments sorted by id' do
        get :index, params: { tid_sort: 'desc' }
        json_response = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json_response.first['id']).to be > json_response.last['id']  # Should return investments in descending order
      end

      it 'applies pagination when requested' do
        get :index, params: { toffset: 0, tlimit: 1 }

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json_response.length).to eq(1)  # Only 1 investment should be returned
      end
    end

    context 'when the investor is not found' do
      before do
        investor.destroy  # Simulate missing investor
      end

      it 'returns a not found error' do
        get :index

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json_response['error']).to eq('Investor not found')
      end
    end
  end

  describe 'GET #show' do
    it 'returns the requested investment' do
      get :show, params: { id: investment.id }

      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json_response['id']).to eq(investment.id)
    end

    it 'returns an error if the investment does not belong to the current user' do
      other_investment = create(:investment)  # Investment by a different user

      get :show, params: { id: other_investment.id }

      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:not_found)
      expect(json_response['error']).to eq('Investment not found')
    end
  end

  describe 'POST #create' do
    context 'when the investor exists' do
      it 'creates a new investment' do
        expect {
          post :create, params: { investment: { offering_id: offering.id, amount: 1000 } }
        }.to change(Investment, :count).by(1)

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:created)
        expect(json_response['amount']).to eq(1000)
      end
    end

    context 'when the investor does not exist' do
      before do
        investor.destroy  # Simulate missing investor
      end

      it 'returns a not found error' do
        post :create, params: { investment: { offering_id: offering.id, amount: 1000 } }

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json_response['error']).to eq('Investor not found')
      end
    end
  end

  describe 'PUT #update' do
    context 'when the investment exists' do
      it 'updates the investment amount' do
        put :update, params: { id: investment.id, investment: { amount: 2000 } }

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json_response['amount']).to eq(2000)
      end
    end

    context 'when the investment does not exist' do
      it 'returns a not found error' do
        put :update, params: { id: 'nonexistent', investment: { amount: 2000 } }

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:not_found)
        expect(json_response['error']).to eq('Investment not found')
      end
    end
  end

  describe 'PUT #approve' do
    context 'when the investment is successfully approved' do
      it 'approves the investment and returns the updated investment' do
        put :approve, params: { id: investment.id }

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(json_response['status']).to eq('approved')
      end
    end

    context 'when the investment cannot be approved' do
      it 'returns an error' do
        allow(investment).to receive(:approve!).and_return(false)  # Simulate approval failure

        put :approve, params: { id: investment.id }

        json_response = JSON.parse(response.body)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).not_to be_empty
      end
    end
  end

  describe 'POST #upload_bank_statement' do
    it 'uploads the bank statement successfully' do
      file = fixture_file_upload('spec/fixtures/sample_statement.pdf', 'application/pdf')  # Add a sample PDF file

      post :upload_bank_statement, params: { id: investment.id, file: file }

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['investment']['id']).to eq(investment.id)
    end

    it 'returns an error if the file upload fails' do
      post :upload_bank_statement, params: { id: investment.id, file: nil }

      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq('Failed to upload file')
    end
  end
end
