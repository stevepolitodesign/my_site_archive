require 'test_helper'

class CreateScreenshotsJobTest < ActiveJob::TestCase
  def setup
    Website.destroy_all
    Webpage.destroy_all
    Screenshot.destroy_all
    @subscribed_user          = users(:subscribed_user_with_websites)
    @subscribed_user_website  = @subscribed_user.websites.create(title: "title", url: "https://www.example.com")
    @subscribed_userwebpage   = @subscribed_user_website.webpages.create(title: "title", url: "https://www.example.com")
    @free_trial_user          = users(:sample_user_on_generic_trial)
    @free_trial_user_website  = @free_trial_user.websites.create(title: "title", url: "https://www.example.com")
    @free_trial_user_webpage  = @free_trial_user_website.webpages.create(title: "title", url: "https://www.example.com")    
    VCR.insert_cassette name
  end

  def teardown
    VCR.eject_cassette
  end

  test "should create screenshots and html_documents" do
    perform_enqueued_jobs do
      CreateScreenshotsJob.perform_now
      assert_equal 2, Screenshot.count
      assert_equal 2, HtmlDocument.count
      
      travel_to 1.day.from_now
      CreateScreenshotsJob.perform_now
      assert_equal 2, Screenshot.count
      assert_equal 2, HtmlDocument.count

      travel_to 1.week.from_now
      CreateScreenshotsJob.perform_now
      assert_equal 4, Screenshot.count
      assert_equal 4, HtmlDocument.count
    end
  end  
end
