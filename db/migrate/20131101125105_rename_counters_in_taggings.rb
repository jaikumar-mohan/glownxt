class RenameCountersInTaggings < ActiveRecord::Migration
  def change
    rename_column :tags, :offered_taggings_count, :capabilities_offered_count
    rename_column :tags, :lookedfor_taggings_count, :capabilities_lookedfor_count
    rename_column :tags, :certifications_count, :company_certification_count
  end
end