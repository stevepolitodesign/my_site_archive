require 'test_helper'

class WebpageTest < ActiveSupport::TestCase
  def setup
    @website = websites(:one)
    @webpage = @website.webpages.build(title: "title", url: @website.url)
    VCR.insert_cassette name
  end

  def teardown
    VCR.eject_cassette
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

  test "should limit the amount of webpages a user has based on their plan" do
    @user = users(:subscribed_user_with_no_websites)
    @website = @user.websites.create(title: "title", url: "https://www.example.com")
    webpage_limit = @user.current_plan.webpage_limit 
    webpage_limit.times do |i|
      @website.webpages.create(title: "title", url: "https://www.example.com/#{i}")
    end
    @webpage = @website.webpages.create(title: "title", url: "https://www.example.com/#{webpage_limit+1}")
    assert_not @webpage.valid?
  end  
  
end
