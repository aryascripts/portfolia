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

    # Get all balances with book values for performance calculation
    all_balances = balances_query
                   .order(recorded_at: :asc)
                   .pluck(:recorded_at, :balance, :book_value, :fx_rate_to_cad)
                   .map do |recorded_at, balance, book_value, fx_rate|
      cad_balance = account.currency == 'CAD' ? balance : balance * fx_rate
      cad_book_value = account.currency == 'CAD' ? book_value : book_value * fx_rate
      [recorded_at.to_date, cad_balance, cad_book_value]
    end

    # Calculate performance percentage
    performance_percentage = calculate_performance_percentage(all_balances)

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
        chart_data = all_balances
      end
    else
      chart_data = all_balances
    end

    # Return chart data and performance info
    {
      chart_data: chart_data.map { |date, balance, _| [date, balance] },
      performance_percentage: performance_percentage
    }
  end

  def self.calculate_performance_percentage(balances)
    return nil if balances.empty? || balances.length < 2

    # For simplicity, we'll calculate a modified time-weighted return
    # that accounts for cash flows between the start and end periods

    first_balance = balances.first
    last_balance = balances.last

    start_date, start_balance, start_book_value = first_balance
    end_date, end_balance, end_book_value = last_balance

    # Calculate net cash flow (positive = deposit, negative = withdrawal)
    # Net cash flow = (End book value - Start book value) - (End balance - Start balance)
    net_cash_flow = (end_book_value - start_book_value) - (end_balance - start_balance)

    # Calculate time-weighted return
    # TWR = (End Balance - Net Cash Flow) / (Start Balance + Net Cash Flow) - 1
    if start_balance + net_cash_flow != 0
      twr = (end_balance - net_cash_flow) / (start_balance + net_cash_flow) - 1
      performance_percentage = twr * 100
    else
      performance_percentage = 0
    end

    {
      percentage: performance_percentage.round(2),
      start_balance: start_balance,
      end_balance: end_balance,
      start_book_value: start_book_value,
      end_book_value: end_book_value,
      net_cash_flow: net_cash_flow,
      start_date: start_date,
      end_date: end_date,
      calculation_method: "Modified Time-Weighted Return"
    }
  end
end
