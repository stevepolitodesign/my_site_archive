require 'test_helper'

class HtmlDocumentTest < ActiveSupport::TestCase
  def setup
    @webpage = webpages(:one)
    @html_document = @webpage.html_documents.build(source_code: "source code")
  end

  test "should be valid" do
    assert @html_document.valid?
  end

  test "should have source_code" do
    @html_document.source_code = ""
    assert_not @html_document.valid?
  end
end
