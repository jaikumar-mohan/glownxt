class AddCertificateToTags < ActiveRecord::Migration
  def change
    add_column :tags, :certificate, :boolean, default: false
  end
end
