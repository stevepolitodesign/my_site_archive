require "application_system_test_case"

class WebsiteFlowsTest < ApplicationSystemTestCase
  test "creating a website" do
    visit new_website_path

    fill_in "Title", with: "Title"
    fill_in "Url", with: "https://www.google.com"
    click_button "Create Website"
    
    assert_text "Website created"
    
    take_screenshot
  end
end
