class AddIndexToCompanyRelationUserId < ActiveRecord::Migration
  def change
    add_index :companyrelationships, :user_id, unique: true
  end
end
