class DeleteUnusefulModels < ActiveRecord::Migration
  def change
    drop_table :glows
    drop_table :glow_comments
    drop_table :messages
  end
end
