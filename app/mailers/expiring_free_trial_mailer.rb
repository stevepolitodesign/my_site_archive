class ExpiringFreeTrialMailer < ApplicationMailer
  include ActionView::Helpers::DateHelper

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.expiring_free_trial_mailer.reminder.subject
  #
  def reminder(user:)
    @user       = user
    @expiration = @user.trial_ends_at
    @subject    = "Your free trail to My Site Archive expires in #{time_ago_in_words(@expiration)}."

    mail to: @user.email, subject: @subject
  end
end
