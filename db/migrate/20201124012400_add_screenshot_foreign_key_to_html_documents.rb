class AddScreenshotForeignKeyToHtmlDocuments < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :html_documents, :screenshots, validate: false
  end
end
