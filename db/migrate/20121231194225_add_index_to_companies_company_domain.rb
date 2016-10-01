class AddIndexToCompaniesCompanyDomain < ActiveRecord::Migration
  def change
    add_index :companies, :company_name, unique: true
    add_index :companies, :company_domain, unique: true
  end
end
