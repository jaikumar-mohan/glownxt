class AddPhonePrefixToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :phone_prefix, :string
  end
end
