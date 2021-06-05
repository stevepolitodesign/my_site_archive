require "application_system_test_case"

class WebsiteFlowsTest < ApplicationSystemTestCase
  def setup
    @user         = users(:subscribed_user_with_websites)
    @another_user = users(:subscribed_user_with_no_websites)
    @website      = @user.websites.first
    VCR.insert_cassette name
  end

  def teardown
    VCR.eject_cassette
  end

  test "creating a website" do
    sign_in @user
    visit new_website_path

    assert_difference ->{ Website.count } => 1, ->{ ZoneFile.count } => 1 do
      fill_in "Title", with: "Title"
      fill_in "URL", with: "www.example.com"
      click_button "Create Website"
      sleep 5
    end
    
    assert_text "Website created"
    assert @user.websites.reload.last.image.attached?
    
    take_screenshot
  end

  test "editing a website" do
    sign_in @user
    visit edit_website_path(@website)

    fill_in "Title", with: "Updated Title"
    click_button "Update Website"

    assert_text "Website updated"

    take_screenshot
  end

  test "deleting a website" do
    sign_in @user
    visit edit_website_path(@website)

    assert_difference("Website.count", -1) do
      accept_confirm do
        click_link "Delete Website"
      end
      sleep 5
    end

    assert_text "Website deleted."

    take_screenshot
  end

  test "preventing a user from editing another's website" do
    sign_in @another_user

    visit edit_website_path(@website)
    assert_user_not_authorized

    take_screenshot
  end

  test "preventing a user from viewing another's website" do
    visit website_path(@website)
    assert_user_authenticated

    sign_in @another_user
    visit website_path(@website)
    assert_user_not_authorized
  end

end
