# spec/factories/investors.rb
FactoryBot.define do
  factory :investor do
    association :user
    kyc_status { "approved" }
    kyc_verified_at { nil }
  end
end