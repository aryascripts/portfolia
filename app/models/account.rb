class Account < ApplicationRecord
  ACCOUNT_TYPES = %w[chequing savings investment credit_card].freeze

  has_many :account_balances, dependent: :destroy
  has_many :holdings, dependent: :destroy

  validates :name, presence: true
  validates :account_type, presence: true, inclusion: { in: ACCOUNT_TYPES }
  validates :currency, presence: true, length: { is: 3 }

  def latest_balance
    account_balances.order(recorded_at: :desc).first
  end

  def current_balance
    latest_balance&.balance || 0
  end
end
