# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    let(:user) { FactoryBot.build(:user) }

    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without an email' do
      user.email = nil
      expect(user).to_not be_valid
    end

    it 'is not valid without a password' do
      user.password = nil
      expect(user).to_not be_valid
    end

    context 'when email is already taken' do
      let!(:existing_user) { FactoryBot.create(:user, email: 'openclade@gmail.com') }

      it 'is not valid with a duplicate email' do
        user.email = 'openclade@gmail.com'
        expect(user).to_not be_valid
      end
    end
  end
end