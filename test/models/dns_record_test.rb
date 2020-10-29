require 'test_helper'

class DnsRecordTest < ActiveSupport::TestCase
  def setup
    @zone_file = zone_files(:one)
    @dns_record = @zone_file.dns_records.build(record_type: "a", content: "content")
  end

  test "should be valid" do
    assert @dns_record.valid?
  end

  test "should have a type" do
    @dns_record.record_type = nil
    assert_not @dns_record.valid?
  end

  test "should have content" do
    @dns_record.content = ""
    assert_not @dns_record.valid?
  end 
end
