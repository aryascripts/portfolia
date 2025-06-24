class AddUserIdToAccounts < ActiveRecord::Migration[7.1]
  def up
    # First add the column as nullable
    add_reference :accounts, :user, null: true, foreign_key: true

    # Get or create a default user for existing accounts
    default_user = User.find_or_create_by(email: 'default@example.com') do |user|
      user.password = 'password123'
      user.password_confirmation = 'password123'
    end

    # Update all existing accounts to belong to the default user
    Account.update_all(user_id: default_user.id)

    # Now make the column non-nullable
    change_column_null :accounts, :user_id, false
  end

  def down
    remove_reference :accounts, :user, foreign_key: true
  end
end
