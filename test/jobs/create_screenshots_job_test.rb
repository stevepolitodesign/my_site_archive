require 'test_helper'

class CreateScreenshotsJobTest < ActiveJob::TestCase
  def setup
    Website.destroy_all
    @user     = users(:subscribed_user_with_websites)
    @website  = @user.websites.create(title: "title", url: "https://www.example.com")
    @webpage  = @website.webpages.create(title: "title", url: "https://www.example.com")
    VCR.insert_cassette name
  end

  def teardown
    VCR.eject_cassette
  end

  test "should create screenshots and html_documents" do
    perform_enqueued_jobs do
      CreateScreenshotsJob.perform_now
      assert_equal 1, Screenshot.count
      assert_equal 1, HtmlDocument.count
      
      travel_to 1.week.from_now
      CreateScreenshotsJob.perform_now
      assert_equal 2, Screenshot.count
      assert_equal 2, HtmlDocument.count
    end
  end  
end
