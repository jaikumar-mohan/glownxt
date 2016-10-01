class AddCompanyIdAndUserIdToCompanyrelationship < ActiveRecord::Migration
  def change
    add_column :companyrelationships, :company_id, :integer
    add_column :companyrelationships, :user_id, :integer
  end
end
