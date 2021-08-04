class AddNullContraintOnUuidToArchives < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      execute 'ALTER TABLE "archives" ADD CONSTRAINT "archives_uuid_null" CHECK ("uuid" IS NOT NULL) NOT VALID' 
    end
  end
end
