class CreateZoneFilesJob < ApplicationJob
  queue_as :default

  before_perform :set_users

  def perform
    @users.find_in_batches(batch_size: 100) do |group|
      group.each do |user|
        user.update_websites_zone_file
      end
    end
  end

  private

    def set_users
      @users = User.with_active_subscriptions.with_websites.includes(:websites)
    end
end
