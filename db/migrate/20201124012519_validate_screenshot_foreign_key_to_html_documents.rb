class ValidateScreenshotForeignKeyToHtmlDocuments < ActiveRecord::Migration[6.0]
  def change
    validate_foreign_key :html_documents, :screenshots
  end
end
