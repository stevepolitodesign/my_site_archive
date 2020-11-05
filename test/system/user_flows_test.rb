require "application_system_test_case"

class UserFlowsTest < ApplicationSystemTestCase
  test "creating an account" do
    visit new_user_registration_path
    
    fill_in "Email", with: "example@example.com"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"

    take_screenshot
  end
end
