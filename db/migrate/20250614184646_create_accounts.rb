class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.string :account_type, null: false
      t.string :currency, null: false, default: 'CAD'

      t.timestamps
    end

    add_index :accounts, :account_type
  end
end
