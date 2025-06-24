class AllowNullApplicationIdInAccessTokens < ActiveRecord::Migration[7.1]
  def change
    change_column_null :oauth_access_tokens, :application_id, true
  end
end
