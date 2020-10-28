class CreateHtmlDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :html_documents do |t|
      t.references :webpage, null: false, foreign_key: true
      t.text :source_code, null: false

      t.timestamps
    end
  end
end
