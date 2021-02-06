namespace :expiring_free_trial_reminder do
  desc "TODO"
  task perform: :environment do
    ExpiringFreeTrialReminderJob.perform_later
  end

end
