require 'test_helper'

class WebsiteTest < ActiveSupport::TestCase
  def setup
    @website = Website.new(title: "title", url: "https://www.example.com")
  end

  test "should be valid" do
    assert @website.valid?
  end

  test "should have a title" do
    @website.title = ""
    assert_not @website.valid?
  end

  test "should have a url" do
    @website.url = ""
    assert_not @website.valid?
  end

  test "should have a valid url" do
    invalid_urls = %w(example.com www http:\/\/)
    invalid_urls.each do |invalid_url|
      @website.url = invalid_urls
      assert_not @website.valid?
    end
  end

  test "should only save subdomain and domain as url" do
    @website.url = "https://www.example.com/some/path"
    @website.save
    assert_equal "https://www.example.com/", @website.reload.url
  end

  test "should destroy associated webpages" do
    @website.save
    @website.webpages.create(title: "title", url: "some/path")
    assert_difference("Webpage.count", -1) do
      @website.destroy
    end
  end
end
