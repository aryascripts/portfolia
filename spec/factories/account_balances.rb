FactoryBot.define do
  factory :account_balance do
    association :account
    balance { rand(1000.0..10000.0).round(2) }
    book_value { rand(800.0..9000.0).round(2) }
    recorded_at { Time.current }
  end
end
