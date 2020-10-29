require 'test_helper'

class ZoneFileTest < ActiveSupport::TestCase
  def setup
    @website = websites(:one)
    @zone_file = @website.zone_files.build
  end

  test "should be valid" do
    assert @zone_file.valid?
  end

  test "should destroy associated dns_records" do
    @zone_file.save
    @zone_file.dns_records.create(record_type: "a", content: "content")
    assert_difference("DnsRecord.count", -1) do
      @zone_file.destroy
    end
  end
end