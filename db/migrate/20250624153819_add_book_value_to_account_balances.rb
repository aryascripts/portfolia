class AddBookValueToAccountBalances < ActiveRecord::Migration[7.1]
  def change
    add_column :account_balances, :book_value, :decimal, precision: 20, scale: 2, null: false, default: 0
  end
end
