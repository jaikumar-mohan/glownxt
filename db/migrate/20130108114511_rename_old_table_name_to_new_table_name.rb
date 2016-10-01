class RenameOldTableNameToNewTableName < ActiveRecord::Migration
  def self.up
    rename_table :companyrelationships, :company_relationships
  end
  def self.down
    rename_table :company_relationships, :companyrelationships
  end

end
