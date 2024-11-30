# spec/factories/offerings.rb
FactoryBot.define do
  factory :offering do
    name { "Test Offering" }
    status { "pending" }
    target_amount { 100_000 }
    min_invest_amount { 500 }
    min_target { 10_000 }
    max_target { 50_000 }
    total_investors { 0 }
    current_reserved_amount { 0 }
    funded_amount { 0 }
    reserved_investors { 0 }
  end
end