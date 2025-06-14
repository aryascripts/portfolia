class AccountBalance < ApplicationRecord
  belongs_to :account

  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :recorded_at, presence: true
  validates :recorded_at, uniqueness: { scope: :account_id }

  scope :ordered, -> { order(recorded_at: :desc) }
  scope :most_recent, -> { order(recorded_at: :desc) }
end
