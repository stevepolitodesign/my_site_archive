class CreatePlans < ActiveRecord::Migration[6.0]
  def change
    create_table :plans do |t|
      t.string :name, null: false
      t.integer :price_in_cents
      t.string :processor_id

      t.timestamps
    end
  end
end
