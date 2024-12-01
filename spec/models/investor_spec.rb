# spec/models/investor_spec.rb
require 'rails_helper'

RSpec.describe Investor, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:investor) { FactoryBot.build(:investor, user: user, kyc_status: :approved) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(investor).to be_valid
    end

    it 'is not valid without a kyc_status' do
      investor.kyc_status = nil
      expect(investor).to_not be_valid
    end

    it 'is not valid without a user' do
      investor.user = nil
      expect(investor).to_not be_valid
    end

    it 'is not valid with a duplicate user_id' do
      Investor.create(user: user, kyc_status: :approved)
      expect(investor).to_not be_valid
    end
  end

  describe 'Enums' do
    it 'has the correct kyc_status values' do
      expect(Investor.kyc_statuses.keys).to match_array(%w[pending approved])
    end
  end

  describe 'Instance Methods' do
    before { investor.save! }

    describe '#approve_kyc!' do
      it 'updates kyc_status to approved' do
        investor.approve_kyc!
        expect(investor.kyc_status).to eq('approved')
      end
    end

    describe '#revoke_kyc!' do
      it 'updates kyc_status to pending' do
        investor.approve_kyc! # Ensure status starts as approved
        investor.revoke_kyc!
        expect(investor.kyc_status).to eq('pending')
      end
    end
  end
end
