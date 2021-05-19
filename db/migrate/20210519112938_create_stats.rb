class CreateStats < ActiveRecord::Migration[6.0]
  def change
    create_table :stats do |t|
      t.jsonb :payload, default: {}
      t.jsonb :score, default: {}
      t.references :screenshot, null: false, foreign_key: true

      t.timestamps
    end
  end
end
