require 'test_helper'

class ScreenshotTest < ActiveSupport::TestCase
  def setup
    @webpage = webpages(:one)
    @screenshot = @webpage.screenshots.build
  end

  test "should be valid" do
    assert @screenshot.valid?
  end
end
