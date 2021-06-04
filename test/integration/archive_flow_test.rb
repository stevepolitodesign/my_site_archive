require 'test_helper'

class ArchiveFlowTest < ActionDispatch::IntegrationTest
  def setup
    @archive_website        = websites(:archive)
    @archive_html_document  = html_documents(:archive)
    @guest_user             = users(:guest_user)
    VCR.insert_cassette name
  end

  def teardown
    VCR.eject_cassette
  end

  test "archive a website" do
    get "/free-website-archive-tool"
    assert_response :success
    assert_select "form"
    assert_difference(["Archive.count","Website.count", "Webpage.count", "Screenshot.count", "ZoneFile.count", "HtmlDocument.count", "Stat.count"], 1) do
      assert_emails 0 do
        create_archive
        perform_enqueued_jobs
      end
    end
    assert_redirected_to Archive.last
    follow_redirect!
    assert_match "https://www.google.com/", @response.body
  end

  test "can view source code" do
    get website_html_document_path(@archive_website, @archive_html_document)
    assert_response :success
  end

  test "redirect user to registration form when they hit their limit" do
    get "/free-website-archive-tool"
    0.upto(Archive::GUEST_USER_LIMIT) do |index|
      create_archive
      get "/free-website-archive-tool"
    end
    get "/free-website-archive-tool"
    assert_no_difference("Archive.count") do
      create_archive
    end
    assert_redirected_to new_user_registration_path
  end

  private

    def create_archive
      post archives_path, params: {
        archive: {
          url: "https://www.google.com/"
        }
      }      
    end
end