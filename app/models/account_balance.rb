class AccountBalance < ApplicationRecord
  belongs_to :account

  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :recorded_at, presence: true
  validates :recorded_at, uniqueness: { scope: :account_id }
  validates :book_value, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :fx_rate_to_cad, numericality: { greater_than: 0 }

  def cad_balance
    return balance if account.currency == 'CAD'

    balance * fx_rate_to_cad
  end

  scope :ordered, -> { order(recorded_at: :desc) }
  scope :most_recent, -> { order(recorded_at: :desc) }

  def self.chart_data_for_account(account, period: nil, resolution: nil)
    # Apply time period filter if specified
    balances_query = where(account: account)

    if period.present?
      case period
      when '3_days'
        balances_query = balances_query.where('recorded_at >= ?', 3.days.ago)
      when '7_days'
        balances_query = balances_query.where('recorded_at >= ?', 7.days.ago)
      when '1_month'
        balances_query = balances_query.where('recorded_at >= ?', 1.month.ago)
      when '3_months'
        balances_query = balances_query.where('recorded_at >= ?', 3.months.ago)
      when '6_months'
        balances_query = balances_query.where('recorded_at >= ?', 6.months.ago)
      when '1_year'
        balances_query = balances_query.where('recorded_at >= ?', 1.year.ago)
      end
    end

    # Get all balances and convert to CAD
    all_balances = balances_query
                   .order(recorded_at: :asc)
                   .pluck(:recorded_at, :balance, :fx_rate_to_cad)
                   .map do |recorded_at, balance, fx_rate|
      cad_balance = account.currency == 'CAD' ? balance : balance * fx_rate
      [recorded_at.to_date, cad_balance]
    end

                # Limit to max data points with intelligent sampling (only if not 'all')
    if resolution.present? && resolution != 'all'
      max_points = resolution.to_i

      if all_balances.length > max_points
        # Calculate step size to get approximately max_points
        step = (all_balances.length / max_points.to_f).ceil
        chart_data = all_balances.each_slice(step).map(&:first)

        # Always include the first and last data points
        chart_data = [all_balances.first] + chart_data[1..-2] + [all_balances.last] if chart_data.length > 2
        chart_data
      else
        all_balances
      end
    else
      all_balances
    end
  end
end
