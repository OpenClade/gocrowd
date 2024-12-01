# spec/factories/investments.rb
FactoryBot.define do
  factory :investment do
    association :investor
    association :offering
    amount { 1000 }
    status { :pending }

    trait :signed do
      status { :signed }
    end

    trait :confirmed do
      status { :confirmed }
    end

    trait :received do
      status { :received }
    end

    trait :hidden do
      status { :hidden }
    end
  end
end