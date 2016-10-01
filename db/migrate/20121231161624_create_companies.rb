class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :company_name
      t.string :company_country
      t.string :company_domain
      t.text :company_profile

      t.timestamps
    end
  end
end
