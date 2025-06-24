class AccountBalance < ApplicationRecord
  belongs_to :account

  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :recorded_at, presence: true
  validates :recorded_at, uniqueness: { scope: :account_id }
  validates :book_value, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :fx_rate_to_cad, numericality: { greater_than: 0 }

  def cad_balance
    balance * fx_rate_to_cad
  end

  scope :ordered, -> { order(recorded_at: :desc) }
  scope :most_recent, -> { order(recorded_at: :desc) }
end
