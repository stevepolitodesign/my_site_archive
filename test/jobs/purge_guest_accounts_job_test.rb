require 'test_helper'

class PurgeGuestAccountsJobTest < ActiveJob::TestCase
  test "should destroy guest user and associated records" do
    assert_difference(["Archive.count","Website.count", "Webpage.count", "Screenshot.count", "ZoneFile.count", "HtmlDocument.count", "Stat.count"], -1) do
      PurgeGuestAccountsJob.perform_now
    end
  end
end
