class AddFxRateToCadToAccountBalances < ActiveRecord::Migration[7.1]
  def change
    add_column :account_balances, :fx_rate_to_cad, :decimal, precision: 15, scale: 6, null: false, default: 1.0
  end
end
