class CreateGlowComments < ActiveRecord::Migration
  def change
    create_table :glow_comments do |t|
      t.integer :glow_id
      t.integer :user_id
      t.text :content

      t.timestamps
    end
  end
end
