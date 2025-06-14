FactoryBot.define do
  factory :account do
    sequence(:name) { |n| "Account #{n}" }
    account_type { Account::ACCOUNT_TYPES.sample }
    currency { "CAD" }

    trait :with_balances do
      after(:create) do |account|
        create_list(:account_balance, 3, account: account)
      end
    end

    trait :with_holdings do
      after(:create) do |account|
        create_list(:holding, 2, account: account)
      end
    end
  end
end
