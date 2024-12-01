# spec/models/offering_spec.rb
require 'rails_helper'

RSpec.describe Offering, type: :model do
  let(:offering) do
    FactoryBot.build(:offering,
      name: 'Tech Startup',
      min_invest_amount: 1000,
      min_target: 50000,
      max_target: 100000,
      total_investors: 10,
      current_reserved_amount: 20000,
      funded_amount: 30000,
      reserved_investors: 5,
      target_amount: 75000,
      can_advance_state: true,
      status: :draft
    )
  end

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(offering).to be_valid
    end

    it 'is valid change state from draft to collecting' do
      offering.start_collecting
      expect(offering.status).to eq('collecting')
    end

    it 'is valid change state from collecting to closed' do
      offering.start_collecting
      offering.close
      expect(offering.status).to eq('closed')
    end

    it 'is valid change state from closed to completed' do
      offering.start_collecting
      offering.close
      offering.complete
      expect(offering.status).to eq('completed')
    end

    it 'is not valid without a status' do
      offering.status = nil
      expect(offering).to_not be_valid
    end

    it 'is not valid if status equal to draft, but state going to closed' do
      offering.status = 'draft'
      offering.close
      expect(offering.status).to_not eq('closed')
    end

    it 'is not valid without a name' do
      offering.name = nil
      expect(offering).to_not be_valid
    end
  end

  describe 'Callbacks' do
    it 'calls handle_investments_on_complete when status is completed' do
      offering.start_collecting
      offering.close
      expect(offering).to receive(:handle_investments_on_complete)
      offering.complete
    end
  end
end