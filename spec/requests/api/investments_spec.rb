# spec/requests/investments_spec.rb
require 'rails_helper'

RSpec.describe 'Investments API', type: :request do
  let(:user) { create(:user) }
  let(:investor) { create(:investor, user: user) }
  let(:investment) { create(:investment, investor: investor) }
  let(:headers) { { Authorization: "Bearer #{JWT.encode({ user_id: user.id }, ENV['SECRET_KEY'])}" } }

  describe 'POST /investments/:id/upload_bank_statement' do
    let(:file) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'bank_statement.pdf'), 'application/pdf') }

    it 'uploads a bank statement and returns the file URL' do
      post upload_bank_statement_investment_path(investment), params: { file: file }, headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to have_key('url')
    end

    it 'returns an error if no file is provided' do
      post upload_bank_statement_investment_path(investment), headers: headers

      expect(response).to have_http_status(:bad_request)
      expect(JSON.parse(response.body)).to have_key('error')
    end
  end
end