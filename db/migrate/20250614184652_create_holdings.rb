class CreateHoldings < ActiveRecord::Migration[7.1]
  def change
    create_table :holdings do |t|
      t.references :account, null: false, foreign_key: { on_delete: :cascade }
      t.string :symbol, null: false
      t.decimal :quantity, precision: 20, scale: 6, null: false
      t.decimal :average_price, precision: 20, scale: 4, null: false
      t.decimal :current_price, precision: 20, scale: 4, null: false

      t.timestamps
    end

    add_index :holdings, [:account_id, :symbol], unique: true
    add_index :holdings, :symbol
  end
end
