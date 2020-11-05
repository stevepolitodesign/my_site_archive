class ValidateForeignKeyToWebsites < ActiveRecord::Migration[6.0]
  def change
    validate_foreign_key :websites, :users
  end
end
