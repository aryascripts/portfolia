class Holding < ApplicationRecord
  belongs_to :account

  validates :symbol, presence: true, uniqueness: { scope: :account_id }
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :average_price, presence: true, numericality: { greater_than: 0 }
  validates :current_price, presence: true, numericality: { greater_than: 0 }
  validates :purchase_price, presence: true, numericality: { greater_than: 0 }
  validates :purchase_date, presence: true

  def market_value
    quantity * current_price
  end

  def cost_basis
    quantity * average_price
  end

  def unrealized_gain_loss
    market_value - cost_basis
  end

  def unrealized_gain_loss_percentage
    return 0 if cost_basis.zero?
    (unrealized_gain_loss / cost_basis) * 100
  end

  def gain_loss
    (current_price - purchase_price) * quantity
  end
end
