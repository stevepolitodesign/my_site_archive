class AddUuidToArchives < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!
  def change
    add_column :archives, :uuid, :string
    add_index :archives, :uuid, unique: true, algorithm: :concurrently
  end

end
