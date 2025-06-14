module CurrencyHelper
  def format_currency_with_code(amount, currency = 'CAD')
    return "—" if amount.nil?

    # Format the number with commas and 2 decimal places
    formatted_amount = number_with_precision(
      amount,
      precision: 2,
      delimiter: ',',
      separator: '.'
    )

    # Add currency symbol and code
    "$#{formatted_amount} #{currency}"
  end
end
