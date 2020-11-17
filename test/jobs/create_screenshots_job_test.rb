require 'test_helper'

class CreateScreenshotsJobTest < ActiveJob::TestCase
  # TODO: Use VCR
  test "should create screenshots" do
    assert_equal 2, Screenshot.count
    
    travel_to 1.week.from_now
    perform_enqueued_jobs do
      CreateScreenshotsJob.perform_now
    end
    assert_equal 4, Screenshot.count
  end  
end
