require 'test_helper'

class StatTest < ActiveSupport::TestCase
  setup do
    @screenshot = screenshots(:one)
    @stat = @screenshot.build_stat
  end

  test "should be valid" do
    assert @stat.valid?
  end
end
