require "application_system_test_case"

class WebsiteFlowsTest < ApplicationSystemTestCase
  def setup
    @user = users(:subscribed_user_with_websites)
    VCR.insert_cassette name
  end

  def teardown
    VCR.eject_cassette
  end

  test "creating a website" do
    sign_in @user
    visit new_website_path

    fill_in "Title", with: "Title"
    fill_in "Url", with: "https://www.example.com"
    click_button "Create Website"
    
    assert_text "Website created"
    
    take_screenshot
  end

  test "preventing a user from editing another's website" do
    skip
  end

  test "preventing a user from viewing another's website" do
    skip
  end
end
