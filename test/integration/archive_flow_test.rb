require 'test_helper'

class ArchiveFlowTest < ActionDispatch::IntegrationTest
  def setup
    VCR.insert_cassette name
  end

  def teardown
    VCR.eject_cassette
  end

  test "archive a weebsite" do
    get "/free-website-archive-tool"
    assert_response :success
    assert_select "form"
    assert_difference(["Archive.count","Website.count", "Webpage.count", "Screenshot.count", "ZoneFile.count", "HtmlDocument.count", "Stat.count"], 1) do
      post archives_path, params: {
        archive: {
          url: "http://example.com/foo.html"
        }
      }
      perform_enqueued_jobs
    end
    assert_redirected_to Archive.last
    follow_redirect!
    assert_match "http://example.com/foo.html", @response.body
  end

  test "can view source code" do
    # TODO: Create some fixture data for this. 
    flunk
  end
end