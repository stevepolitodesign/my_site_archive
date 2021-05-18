require 'test_helper'

class HtmlDocumentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @another_user   = users(:sample_user_with_pending_data)
    @user           = users(:sample_user)
    @website        = @user.websites.last
    @webpage        = @website.webpages.last
    @screenshot     = @webpage.latest_screenshot
    @html_document  = @screenshot.html_document
  end

  test "should get show" do
    sign_in @user
    get website_html_document_path(@website, @html_document)
    assert_response :success
  end

  test "should redirect when not authorized" do
    sign_in @another_user
    get website_html_document_path(@website, @html_document)
    assert_response :redirect
  end

end
