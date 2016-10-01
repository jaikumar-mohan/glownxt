class ChangeFieldsInAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :country_id, :integer, default: 0
    add_column :addresses, :state_id, :integer, default: 0
  end
end
