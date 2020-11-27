class AddScreenshotIdToHtmlDocuments < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_reference :html_documents, :screenshot, null: false, index: {algorithm: :concurrently}
  end
end
