FactoryBot.define do
  factory :account_balance do
    association :account
    balance { rand(1000.0..10000.0).round(2) }
    book_value { rand(800.0..9000.0).round(2) }
    fx_rate_to_cad { [1.25, 1.35].sample }
    recorded_at { Time.current }
  end
end
