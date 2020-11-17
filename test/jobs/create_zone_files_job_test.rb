require 'test_helper'

class CreateZoneFilesJobTest < ActiveJob::TestCase
  # TODO: Use VCR
  test "should create zone files" do
    assert_equal 2, ZoneFile.count
    
    travel_to 1.week.from_now
    perform_enqueued_jobs do
      CreateZoneFilesJob.perform_now
    end
    assert_equal 4, ZoneFile.count
  end
end
