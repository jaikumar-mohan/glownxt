class CreateCompanyrelationships < ActiveRecord::Migration
  def change
    create_table :companyrelationships do |t|

      t.timestamps
    end
  end
end
