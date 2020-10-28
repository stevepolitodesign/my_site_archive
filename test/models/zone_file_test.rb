require 'test_helper'

class ZoneFileTest < ActiveSupport::TestCase
  def setup
    @website = websites(:one)
    @zone_file = @website.zone_files.build
  end

  test "should be valid" do
    assert @zone_file.valid?
  end
end