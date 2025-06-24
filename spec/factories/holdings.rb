FactoryBot.define do
  factory :holding do
    association :account
    sequence(:symbol) { |n| "STOCK#{n}" }
    quantity { rand(1..100) }
    average_price { rand(10.0..100.0).round(2) }
    current_price { rand(10.0..100.0).round(2) }
  end
end
