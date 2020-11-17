class CreatePlans < ActiveRecord::Migration[6.0]
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.integer :price_in_cents
      t.string :processor_id
      t.integer :interval, null: false, default: 0
      t.boolean :public, null: false, default: false
      t.integer :website_limit
      t.integer :webpage_limit
      t.integer :job_schedule_frequency, null: false, default: 0
      t.string :uuid
      t.index :uuid, unique: true

      t.timestamps
    end
  end
end
