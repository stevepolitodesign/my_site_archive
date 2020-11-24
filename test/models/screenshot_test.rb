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
end
