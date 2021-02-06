require 'test_helper'

class ExpiringFreeTrialReminderJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  def setup
    User.destroy_all
    @user = User.create(
      email: "user@example.com",
      password: "password",
      password_confirmation: "password",
      confirmed_at: Time.zone.now,
      accepted_terms: true,
      trial_ends_at: 30.days.from_now
    )
  end

  test "should deliver reminder email" do
    assert_no_emails do
      ExpiringFreeTrialReminderJob.perform_now(number_of_days_left: 2)
    end

    travel_to(@user.trial_ends_at - 2.days)
    assert_emails 1 do
      ExpiringFreeTrialReminderJob.perform_now(number_of_days_left: 2)
    end
  end
end
