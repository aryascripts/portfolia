class AddFieldsToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :external_id, :string
    add_column :accounts, :institution, :string
    add_column :accounts, :book_value, :decimal, precision: 20, scale: 2, null: false, default: 0
  end
end
