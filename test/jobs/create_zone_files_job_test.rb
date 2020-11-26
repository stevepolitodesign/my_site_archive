require 'test_helper'

class CreateZoneFilesJobTest < ActiveJob::TestCase
  def setup
    ZoneFile.destroy_all
    VCR.insert_cassette name
  end

  def teardown
    VCR.eject_cassette
  end

  test "should create zone files" do
    perform_enqueued_jobs do
      CreateZoneFilesJob.perform_now
      assert_equal Website.with_active_subscribers.count, ZoneFile.count
      
      travel_to 1.week.from_now
      CreateZoneFilesJob.perform_now
      assert_equal Website.with_active_subscribers.count * 2, ZoneFile.count
    end
  end
end
