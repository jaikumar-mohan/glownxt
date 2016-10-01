class AddFirstAndLastNameToUsers < ActiveRecord::Migration

  def up
    rename_column :users, :name, :last_name
    add_column :users, :first_name, :string
  end

  def down
    rename_column :users, :last_name, :name
    remove_column :users, :first_name
  end

end
