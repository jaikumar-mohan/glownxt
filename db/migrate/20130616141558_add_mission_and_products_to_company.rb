class AddMissionAndProductsToCompany < ActiveRecord::Migration

  def up
    add_column :companies, :company_mission, :text
    add_column :companies, :company_services, :text
  end

  def down
    remove_column :companies, :company_mission
    remove_column :companies, :company_services
  end

end
