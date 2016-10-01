class AddWebsiteToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :company_website, :string
  end
end
