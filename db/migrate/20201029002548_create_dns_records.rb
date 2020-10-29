class CreateDnsRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :dns_records do |t|
      t.references :zone_file, null: false, foreign_key: true
      t.text :content, null: false
      t.integer :priority
      t.integer :record_type, null: false

      t.timestamps
    end
  end
end
