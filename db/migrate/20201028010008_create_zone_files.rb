class CreateZoneFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :zone_files do |t|
      t.references :website, null: false, foreign_key: true

      t.timestamps
    end
  end
end
