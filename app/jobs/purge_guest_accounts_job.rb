class PurgeGuestAccountsJob < ApplicationJob
  queue_as :default

  def perform
    User.guest.destroy_all
  end
end
