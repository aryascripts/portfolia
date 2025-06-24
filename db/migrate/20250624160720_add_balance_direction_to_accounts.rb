class AddBalanceDirectionToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :balance_direction, :string, default: 'positive', null: false
  end
end
