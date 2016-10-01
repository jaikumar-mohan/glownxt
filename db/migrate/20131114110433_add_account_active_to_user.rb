class AddAccountActiveToUser < ActiveRecord::Migration
  def change
    add_column :users, :account_active, :boolean, default: true
  end
end
