class ExpiringFreeTrialReminderJob < ApplicationJob
  queue_as :default

  def perform(number_of_days_left: 2)
    @users = User.with_expiring_free_trials_in_days(number_of_days_left)
    @users.each { |user| ExpiringFreeTrialMailer.reminder(user: user).deliver_later }
  end
end
