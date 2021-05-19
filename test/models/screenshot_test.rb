require 'test_helper'

class ScreenshotTest < ActiveSupport::TestCase
  def setup
    @webpage = webpages(:one)
    @screenshot = @webpage.screenshots.build
  end

  test "should be valid" do
    assert @screenshot.valid?
  end

  test "should destroy associated html_documents" do
    @screenshot.save
    @screenshot.create_html_document(source_code: "source code")
    assert_difference("HtmlDocument.count", -1) do
      @screenshot.destroy
    end
  end

  test "width should be between 320 and 3000" do
    invalid_widths = [-1, 319, 3001]
    invalid_widths.each do |invalid_width|
      @screenshot.width = invalid_width
      assert_not @screenshot.valid?
    end
  end

  test "should have default width of 1024" do
    @screenshot.save
    assert_equal 1024, @screenshot.reload.width 
  end
end
