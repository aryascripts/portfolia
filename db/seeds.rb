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
ACCOUNT_TYPES = ['TFSA', 'RRSP', 'Non-Registered', 'Other']
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
    currency: ['CAD', 'USD'].sample
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
  rand(5..10).times do |i|
    # Randomly adjust the balance by ±5%
    adjustment = rand(-0.05..0.05)
    current_balance = (current_balance * (1 + adjustment)).round(2)

    # Create balance record
    AccountBalance.create!(
      account: account,
      balance: current_balance,
      recorded_at: rand(1..30).days.ago
    )
  end

  puts "Created #{account.account_balances.count} balance records for #{account.name}"
end

# Create holdings (optional)
puts "\nCreating holdings..."
accounts.each do |account|
  # Create 2-3 holdings per account, ensuring no duplicate symbols
  available_symbols = SYMBOLS.shuffle
  rand(2..3).times do
    symbol, name = available_symbols.pop
    quantity = rand(1..100).to_f
    average_price = rand(50..500).to_f
    current_price = (average_price * rand(0.8..1.2)).round(2)

    Holding.create!(
      account: account,
      symbol: symbol,
      quantity: quantity,
      average_price: average_price,
      current_price: current_price
    )
  end

  puts "Created #{account.holdings.count} holdings for #{account.name}"
end

puts "\nSeed data creation completed!"
puts "Created:"
puts "- #{Account.count} accounts"
puts "- #{AccountBalance.count} balance records"
puts "- #{Holding.count} holdings"
