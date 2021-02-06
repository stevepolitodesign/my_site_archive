require "application_system_test_case"

class UserFlowsTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper

  def setup
    @user = users(:unsubscribed_user)
  end

  test "creating an account" do
    visit new_user_registration_path
    
    assert_emails 1 do
      fill_in "Email", with: "example@example.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      check "I accept the terms of service and privacy policy"
      click_button "Sign up"
    end

    assert_text "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account."
    assert User.last.on_generic_trial?

    take_screenshot
  end

  test "deleting an account with no subscription" do
    sign_in @user

    visit edit_user_registration_path

    assert_difference("User.count", -1) do
      accept_confirm do
        click_button "Cancel my account and subscription"
      end
      sleep 10
    end

    assert_text "Bye! Your account has been successfully cancelled"

    take_screenshot
  end

  test "rendering form errors" do
    sign_in @user

    visit edit_user_registration_path
    click_button "Update"

    take_screenshot
  end

end
