require 'test_helper'

class CreateHtmlDocumentsJobTest < ActiveJob::TestCase
  # TODO: Use VCR
  test "should create screenshots" do
    assert_equal 2, HtmlDocument.count
    
    travel_to 1.week.from_now
    perform_enqueued_jobs do
      CreateHtmlDocumentsJob.perform_now
    end
    assert_equal 4, HtmlDocument.count
  end 
end
