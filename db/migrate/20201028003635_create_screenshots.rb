class CreateScreenshots < ActiveRecord::Migration[6.0]
  def change
    create_table :screenshots do |t|
      t.references :webpage, null: false, foreign_key: true

      t.timestamps
    end
  end
end
