class PurgeGuestAccountsJob < ApplicationJob
  queue_as :default

  def perform
    User.guest.not_confirmed.destroy_all
  end
end
