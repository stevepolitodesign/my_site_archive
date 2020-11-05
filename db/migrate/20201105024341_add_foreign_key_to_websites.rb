class AddForeignKeyToWebsites < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :websites, :users
  end
end
