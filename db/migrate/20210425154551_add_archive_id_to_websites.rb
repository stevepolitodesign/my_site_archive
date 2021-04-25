class AddArchiveIdToWebsites < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!
  def change
    add_reference :websites, :archive, index: {algorithm: :concurrently}
  end
end
