require 'test_helper'

class ExpiringFreeTrialMailerTest < ActionMailer::TestCase
  include ActionView::Helpers::DateHelper

  test "reminder" do
    user = users(:sample_user_on_generic_trial) 
    mail = ExpiringFreeTrialMailer.reminder(user: user)
    assert_match time_ago_in_words(user.trial_ends_at), mail.subject
    assert_equal [user.email], mail.to
  end

end
