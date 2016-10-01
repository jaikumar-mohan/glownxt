class RemoveStateAndCountryFromAddresses < ActiveRecord::Migration
  def change
    remove_column :addresses, :state, :string
    remove_column :addresses, :country, :string
  end
end
