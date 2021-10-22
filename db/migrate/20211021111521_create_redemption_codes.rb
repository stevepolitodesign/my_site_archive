class CreateRedemptionCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :redemption_codes do |t|
      t.references :plan, null: false, foreign_key: true
      t.string :value, null: false

      t.timestamps
    end

    add_index :redemption_codes, :value, unique: true
  end
end
