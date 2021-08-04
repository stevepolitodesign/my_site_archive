class BackFillUuidColumnOnArchivesTable < ActiveRecord::Migration[6.0]
  def up
    Archive.all.each do |archive|
      archive.update(uuid: SecureRandom.alphanumeric) unless archive.uuid.present?
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
