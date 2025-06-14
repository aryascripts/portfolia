class AccountBalance < ApplicationRecord
  belongs_to :account

  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :recorded_at, presence: true

  scope :ordered, -> { order(recorded_at: :desc) }
end
