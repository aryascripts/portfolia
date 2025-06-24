class CreateAccountBalances < ActiveRecord::Migration[7.1]
  def change
    create_table :account_balances do |t|
      t.references :account, null: false, foreign_key: { on_delete: :cascade }
      t.decimal :balance, precision: 20, scale: 2, null: false
      t.datetime :recorded_at, null: false

      t.timestamps
    end

    add_index :account_balances, [:account_id, :recorded_at]
  end
end
