# Preview all emails at http://localhost:3000/rails/mailers/expiring_free_trial_mailer
class ExpiringFreeTrialMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/expiring_free_trial_mailer/reminder
  def reminder
    ExpiringFreeTrialMailer.reminder(user: User.find_by(email: "sample_user_on_generic_trial@example.com"))
  end

end
