# spec/factories/offerings.rb
FactoryBot.define do
  factory :offering do
    name { "Tech Startup" }
    min_invest_amount { 1000 }
    min_target { 100 }
    max_target { 100000 }
    total_investors { 10 }
    current_reserved_amount { 20000 }
    funded_amount { 30000 }
    reserved_investors { 5 }
    target_amount { 75000 }
    can_advance_state { true }
    status { :collecting }

    trait :collecting do
      status { :collecting }
    end

    trait :closed do
      status { :closed }
    end

    trait :completed do
      status { :completed }
    end
  end
end