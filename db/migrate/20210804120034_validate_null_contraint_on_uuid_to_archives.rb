class ValidateNullContraintOnUuidToArchives < ActiveRecord::Migration[6.0]
  def change
    safety_assured do
      execute 'ALTER TABLE "archives" VALIDATE CONSTRAINT "archives_uuid_null"' 
    end
    change_column_null :archives, :uuid, false
    safety_assured do
      execute 'ALTER TABLE "archives" DROP CONSTRAINT "archives_uuid_null"' 
    end
  end
end
