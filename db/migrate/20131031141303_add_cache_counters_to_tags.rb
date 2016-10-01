class AddCacheCountersToTags < ActiveRecord::Migration
  def change
    add_column :tags, :offered_taggings_count, :integer, default: 0
    add_column :tags, :lookedfor_taggings_count, :integer, default: 0
    add_column :tags, :certifications_count, :integer, default: 0
  end
end
