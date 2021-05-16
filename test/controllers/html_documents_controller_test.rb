require 'test_helper'

class HtmlDocumentsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get html_documents_show_url
    assert_response :success
  end

end
