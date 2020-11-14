require 'test_helper'

class WebsiteTest < ActiveSupport::TestCase
  def setup
    @user = users(:subscribed_user_with_websites)
    @website = @user.websites.build(title: "title", url: "https://www.example.com")
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
    @website.webpages.create(title: "title", url: @website.reload.url)
    assert_difference("Webpage.count", -1) do
      @website.destroy
    end
  end

  test "should destroy associated zone_files" do
    @website.save
    @website.zone_files.create
    assert_difference("ZoneFile.count", -1) do
      @website.destroy
    end
  end
  
  test "associated user should have an active subscription" do
    @unsubscribed_user = users(:unsubscribed_user)
    @website = @unsubscribed_user.websites.build(title: "title", url: "https://www.example.com")
    assert_not @website.valid?
  end
end
