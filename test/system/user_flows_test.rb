require "application_system_test_case"

class UserFlowsTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper

  test "creating an account" do
    visit new_user_registration_path
    
    assert_emails 1 do
      fill_in "Email", with: "example@example.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"
      check "Terms"
      click_button "Sign up"
    end

    assert_text "A message with a confirmation link has been sent to your email address. Please follow the link to activate your account."
  end

  test "deleting an account with no subscription" do
    skip
  end

end
