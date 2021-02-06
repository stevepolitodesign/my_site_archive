require "application_system_test_case"

class FreeTrialFlowsTest < ApplicationSystemTestCase
  def setup
    @user_on_generic_trial          = users(:sample_user_on_generic_trial)
    @user_on_expired_generic_trial  = users(:sample_user_on_expired_generic_trial)
  end


  test "access to websites while on free trial" do
    sign_in @user_on_generic_trial
    visit new_website_path
    assert_text "Add a New Website to Monitor"
    take_screenshot
  end

  test "no access to websites while on expired free trial" do
    sign_in @user_on_expired_generic_trial
    visit new_website_path
    assert_text "Please subscribe to access this feature"
    take_screenshot
  end

  test "rendering free trial expiration" do
    sign_in @user_on_generic_trial
    visit root_path
    assert_text "Your free trial will end in"
    take_screenshot
  end
end
