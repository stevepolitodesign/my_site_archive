class ValidateArchiveForeignKeyToWebsites < ActiveRecord::Migration[6.0]
  def change
    validate_foreign_key :websites, :archives
  end
end
