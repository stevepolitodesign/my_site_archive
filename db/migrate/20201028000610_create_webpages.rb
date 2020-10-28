class CreateWebpages < ActiveRecord::Migration[6.0]
  def change
    create_table :webpages do |t|
      t.references :website, null: false, foreign_key: true
      t.string :title, null: false
      t.string :url, null: false

      t.timestamps
    end
  end
end
