require 'test_helper'

class ArchiveFlowTest < ActionDispatch::IntegrationTest
  test "archive a weebsite" do
    get "/free-website-archive-tool"
    assert_response :success
    assert_select "form"
    assert_difference(["Archive.count","Website.count", "Webpage.count", "Screenshot.count", "ZoneFile.count"], 1) do
      post archives_path, params: {
        archive: {
          url: "http://example.com/foo.html"
        }
      }
    end
    assert_redirected_to Archive.last
    assert_text "http://example.com/foo.html"
  end
end
