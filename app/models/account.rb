class Account < ApplicationRecord
  has_many :account_balances, dependent: :destroy
  has_many :holdings, dependent: :destroy

  validates :name, presence: true
  validates :account_type, presence: true, inclusion: { in: %w[TFSA RRSP Non-Registered Other] }
  validates :currency, presence: true, length: { is: 3 }

  def latest_balance
    account_balances.ordered.first
  end
end
