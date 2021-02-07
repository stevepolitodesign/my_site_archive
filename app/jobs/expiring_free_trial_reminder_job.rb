class ExpiringFreeTrialReminderJob < ApplicationJob
  queue_as :default

  def perform(date: 2.days.from_now.all_day)
    @users = User.with_free_trial_ending_on(date)
    @users.each { |user| ExpiringFreeTrialMailer.reminder(user: user).deliver_later }
  end
end
