require "application_system_test_case"

class WebpageFlowsTest < ApplicationSystemTestCase
  def setup
    @user         = users(:subscribed_user_with_websites)
    @another_user = users(:subscribed_user_with_no_websites)
    @website      = websites(:one)
    @webpage      = @website.webpages.last 
    VCR.insert_cassette name
  end

  def teardown
    VCR.eject_cassette
  end

  test "creating a webpage and associated screenshot html_documen stat" do
    sign_in @user

    visit website_path(@website)
    assert_difference ->{ Screenshot.count } => 1, ->{ HtmlDocument.count } => 1, ->{ Stat.count } => 1 do
      fill_in "Title", with: "Title"
      click_button "Create Webpage"
      sleep 5
    end

    assert_text "Webpage saved."
    assert @website.webpages.reload.last.screenshots.reload.last.image.attached?

    take_screenshot
  end

  test "editing a webpage" do
    sign_in @user

    visit edit_website_webpage_path(@website, @webpage)
    fill_in "Title", with: "Updated Title"
    click_button "Update Webpage"

    assert_text "Webpage updated."

    take_screenshot
  end

  test "deleting a webpage" do
    sign_in @user

    visit edit_website_webpage_path(@website, @webpage)
    assert_difference("Webpage.count", -1) do
      accept_confirm do
        click_link "Delete Webpage"
      end
      sleep 5
    end

    assert_text "Webpage deleted."

    take_screenshot
  end
  
  test "rendering form errors" do
    sign_in @user

    visit edit_website_webpage_path(@website, @webpage)
    fill_in "Url", with: ""
    fill_in "Url", with: "https://foo.com"
    click_button "Update Webpage"

    assert_text "error prevented"

    take_screenshot
  end

  test "preventing a user from viewing another's webpage" do
    visit website_webpage_path(@website, @webpage)
    assert_user_authenticated

    sign_in @another_user
    visit website_webpage_path(@website, @webpage)
    assert_user_not_authorized
  end

  test "preventing a user from editing another's webpage" do
    sign_in @another_user
    visit edit_website_webpage_path(@website, @webpage)
    assert_user_not_authorized

    take_screenshot
  end  
end
