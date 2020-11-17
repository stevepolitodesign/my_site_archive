require "application_system_test_case"

class WebpageFlowsTest < ApplicationSystemTestCase
  def setup
    @user = users(:subscribed_user_with_websites)
    @website = websites(:one)
    VCR.insert_cassette name
  end

  def teardown
    VCR.eject_cassette
  end

  test "creating a webpage and associated html_document" do
    sign_in @user

    visit website_path(@website)

    fill_in "Title", with: "Title"
    click_button "Create Webpage"

    sleep 3
    
    take_screenshot
  end

  test "preventing a user from viewing another's webpage" do
    skip
  end  
end
