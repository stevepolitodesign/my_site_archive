require 'test_helper'

class CreateZoneFilesJobTest < ActiveJob::TestCase
  def setup
    Website.destroy_all
    ZoneFile.destroy_all
    @subscribed_user            = users(:subscribed_user_with_websites)
    @subscribed_user_website    = @subscribed_user.websites.create(title: "title", url: "https://www.example.com")
    @free_trial_user            = users(:sample_user_on_generic_trial)
    @free_trial_user_website    = @free_trial_user.websites.create(title: "title", url: "https://www.example.com")    
    VCR.insert_cassette name
  end

  def teardown
    VCR.eject_cassette
  end

  test "should create zone files" do
    perform_enqueued_jobs do
      CreateZoneFilesJob.perform_now
      assert_equal 2, ZoneFile.count
      
      travel_to 1.day.from_now
      CreateZoneFilesJob.perform_now
      assert_equal 2, ZoneFile.count

      travel_to 1.week.from_now
      CreateZoneFilesJob.perform_now
      assert_equal 4, ZoneFile.count
    end
  end
end
