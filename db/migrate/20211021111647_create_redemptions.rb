class CreateRedemptions < ActiveRecord::Migration[6.0]
  def change
    create_table :redemptions do |t|
      t.references :redemption_code, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
