class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :company_id
      t.string :street
      t.string :zip
      t.string :city
      t.string :state
      t.string :country
      t.string :tel

      t.timestamps
    end
  end
end
