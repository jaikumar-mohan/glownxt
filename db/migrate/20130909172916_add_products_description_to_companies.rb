class AddProductsDescriptionToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :products_description, :text
  end
end
