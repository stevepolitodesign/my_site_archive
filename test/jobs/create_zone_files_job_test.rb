require 'test_helper'

class CreateZoneFilesJobTest < ActiveJob::TestCase
  # TODO: Use VCR
  test "should create zone files" do
    assert_equal 2, DnsRecord.count
    CreateZoneFilesJob.perform_now
    sleep 5
    assert_equal 4, DnsRecord.count
  end
end
