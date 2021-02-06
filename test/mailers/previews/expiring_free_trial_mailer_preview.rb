# Preview all emails at http://localhost:3000/rails/mailers/expiring_free_trial_mailer
class ExpiringFreeTrialMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/expiring_free_trial_mailer/reminder
  def reminder
    ExpiringFreeTrialMailer.reminder
  end

end
