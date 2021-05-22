class AddArchivesCountToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :archives_count, :integer, default: 0
  end
end
