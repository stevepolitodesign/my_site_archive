class PurgeArchivesJob < ApplicationJob
  queue_as :default

  def perform
    Archive.from_guest_account.destroy_all
  end
end
