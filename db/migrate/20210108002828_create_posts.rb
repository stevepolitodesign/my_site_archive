class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.integer :status, null: false, default: 0
      t.text :meta_description
      t.string :slug

      t.timestamps
    end
    add_index :posts, :slug, unique: true
  end
end
