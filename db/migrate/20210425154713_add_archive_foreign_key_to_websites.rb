class AddArchiveForeignKeyToWebsites < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :websites, :archives, validate: false
  end
end
