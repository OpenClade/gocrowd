# spec/models/investment_spec.rb
require 'rails_helper'

RSpec.describe Investment, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:investor) { FactoryBot.create(:investor, user: user, kyc_status: :approved) }
  let(:offering) { FactoryBot.create(:offering) }
  let(:investment) { FactoryBot.build(:investment, investor: investor, offering: offering, amount: 50000, status: :pending) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(investment).to be_valid
    end

    it 'is not valid without an amount' do
      investment.amount = nil
      expect(investment).to_not be_valid
    end

    it 'is not valid without a status' do
      investment.status = nil
      expect(investment).to_not be_valid
    end
 

    it 'is not valid if the amount is below the minimum investment' do
      investment.amount = offering.min_target - 1
      expect(investment).to_not be_valid
    end

    it 'is not valid if the amount exceeds the maximum investment' do
      investment.amount = offering.max_target + 1
      expect(investment).to_not be_valid
    end

    it 'is not valid if the investor KYC is not approved' do
      investor.update(kyc_status: :pending)
      expect(investment).to_not be_valid
    end
  end

  describe 'Enums' do
    it 'has the correct status values' do
      expect(Investment.statuses.keys).to match_array(%w[pending signed confirmed received hidden])
    end
  end

  describe 'State Transitions' do
    before { investment.save! }

    it 'can transition from pending to signed' do
      investment.sign
      expect(investment.status).to eq('signed')
    end

    it 'can transition from signed to confirmed' do
      investment.sign
      investment.confirm
      expect(investment.status).to eq('confirmed')
    end

    it 'can transition from confirmed to received' do
      investment.sign
      investment.confirm
      investment.receive
      expect(investment.status).to eq('received')
    end

    it 'can transition to hidden from any state' do
      investment.hide
      expect(investment.status).to eq('hidden')
    end
  end

  describe 'Instance Methods' do
    before { investment.save! }

    describe '#upload_bank_statement' do
      let(:file) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'bank_statement.pdf'), 'application/pdf') }

      it 'attaches a bank statement when a valid file is provided' do
        expect(investment.upload_bank_statement(file)).to be true
        expect(investment.bank_statement).to be_attached
      end

      it 'does not attach a bank statement when no file is provided' do
        expect(investment.upload_bank_statement(nil)).to be false
      end
    end
  end
end
