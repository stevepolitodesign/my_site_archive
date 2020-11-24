require 'test_helper'

class HtmlDocumentTest < ActiveSupport::TestCase
  def setup
    @screenshot = screenshots(:one)
    @html_document = @screenshot.create_html_document(source_code: "source code")
  end

  test "should be valid" do
    assert @html_document.valid?
  end

  test "should have source_code" do
    @html_document.source_code = ""
    assert_not @html_document.valid?
  end
end
