class CreateZoneFilesJob < ApplicationJob
  queue_as :default

  before_perform :set_users

  def perform
    @users.each do |user|
      if user.current_plan.present? && user.current_plan.job_schedule_frequency.present?
        duration = user.current_plan.job_schedule_frequency
        @websites = user.websites
        @websites.each do |website|
          @zone_file = website.latest_zone_file
          CreateZoneFileJob.perform_later(website.id) if @zone_file.nil? || @zone_file.created_at >= 1.send(duration).from_now
        end
      end
    end
  end

  private

    def set_users
      @users = User.with_active_subscriptions.with_websites.includes(:websites)
    end
end
