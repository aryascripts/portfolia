# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

# Clear existing data
puts "Clearing existing data..."
AccountBalance.delete_all
Holding.delete_all
Account.delete_all

# Account types and sample symbols
ACCOUNT_TYPES = %w[chequing savings investment credit_card non_registered]
SYMBOLS = [
  ['AAPL', 'Apple Inc.'],
  ['TSLA', 'Tesla Inc.'],
  ['VFV', 'Vanguard S&P 500 Index ETF'],
  ['XEQT', 'iShares Core Equity ETF'],
  ['BTC', 'Bitcoin'],
  ['ETH', 'Ethereum'],
  ['MSFT', 'Microsoft Corporation'],
  ['GOOGL', 'Alphabet Inc.'],
  ['AMZN', 'Amazon.com Inc.'],
  ['VCN', 'Vanguard FTSE Canada All Cap Index ETF']
]

# Create accounts
puts "\nCreating accounts..."
accounts = []

5.times do |i|
  account = Account.create!(
    name: Faker::Company.name + " Investment Account",
    account_type: ACCOUNT_TYPES.sample,
    currency: ['CAD', 'USD'].sample,
    institution: Faker::Bank.name,
    book_value: rand(8000.0..90000.0).round(2)
  )
  accounts << account
  puts "Created account: #{account.name} (#{account.account_type})"
end

# Create historical balances
puts "\nCreating historical balances..."
accounts.each do |account|
  # Start with a random initial balance between 10,000 and 100,000
  current_balance = rand(10000..100000).to_f

  # Generate 5-10 historical balances
  rand(5..50).times do |i|
    # Randomly adjust the balance by ±5%
    adjustment = rand(-0.05..0.05)
    current_balance = (current_balance * (1 + adjustment)).round(2)
    book_value = (current_balance * rand(0.8..1.2)).round(2)
    # Ensure book_value is >= 0
    book_value = 0 if book_value < 0
    # Create balance record
    fx_rate = account.currency == 'USD' ? 1.35 : 1.0
    AccountBalance.create!(
      account: account,
      balance: current_balance,
      book_value: book_value,
      fx_rate_to_cad: fx_rate,
      recorded_at: rand(1..30).days.ago
    )
  end

  puts "Created #{account.account_balances.count} balance records for #{account.name}"
end

puts "\nSeed data creation completed!"
puts "Created:"
puts "- #{Account.count} accounts"
puts "- #{AccountBalance.count} balance records"
puts "- #{Holding.count} holdings"
