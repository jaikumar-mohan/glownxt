class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :title
      t.text :body
      t.text :brief
      t.references :user

      t.timestamps
    end
    add_index :entries, :user_id
  end
end
