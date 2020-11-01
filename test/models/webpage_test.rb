require 'test_helper'

class WebpageTest < ActiveSupport::TestCase
  def setup
    @website = websites(:one)
    @webpage = @website.webpages.build(title: "title", url: "https://www.example.com")
  end

  test "should be valid" do
    assert @webpage.valid?
  end

  test "should have a title" do
    @webpage.title = ""
    assert_not @webpage.valid?
  end

  test "should have a url" do
    @webpage.title = ""
    assert_not @webpage.valid?
  end
  
  test "should have a valid url" do
    invalid_urls = %w(example.com www http:\/\/)
    invalid_urls.each do |invalid_url|
      @webpage.url = invalid_urls
      assert_not @webpage.valid?
    end
  end

  test "url should match website.url" do
    @webpage.url = "https://www.foo.com/"
    assert_not @webpage.valid?
  end

  test "should destroy associated screenshots" do
    @webpage.save
    @webpage.screenshots.create
    assert_difference("Screenshot.count", -1) do
      @webpage.destroy
    end
  end

  test "should destroy associated html_documents" do
    @webpage.save
    @webpage.html_documents.create(source_code: "source code")
    assert_difference("HtmlDocument.count", -1) do
      @webpage.destroy
    end
  end  
  
end
