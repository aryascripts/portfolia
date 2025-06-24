class Account < ApplicationRecord
  ACCOUNT_TYPES = %w[chequing savings investment credit_card non_registered].freeze

  has_many :account_balances, dependent: :destroy
  has_many :holdings, dependent: :destroy

  validates :name, presence: true
  validates :account_type, presence: true, inclusion: { in: ACCOUNT_TYPES }
  validates :currency, presence: true, length: { is: 3 }
  validates :book_value, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :institution, presence: true

  def latest_balance
    account_balances.order(recorded_at: :desc).first
  end

  def current_balance
    latest_balance&.balance || 0
  end

  def latest_cad_balance
    latest_balance&.cad_balance
  end
end
