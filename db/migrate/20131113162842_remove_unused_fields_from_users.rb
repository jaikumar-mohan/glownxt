class RemoveUnusedFieldsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :state, :string
    remove_column :users, :password_digest, :string
    remove_column :users, :remember_token, :string
    remove_column :users, :password_reset_token, :string
    remove_column :users, :password_reset_sent_at, :string
    remove_column :users, :email_confirmation_token, :string
    remove_column :users, :email_confirmation_sent_at, :string
  end
end
