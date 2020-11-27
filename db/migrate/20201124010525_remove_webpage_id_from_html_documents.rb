class RemoveWebpageIdFromHtmlDocuments < ActiveRecord::Migration[6.0]
  def change
    safety_assured { remove_reference :html_documents, :webpage, null: false, foreign_key: true }
  end
end
