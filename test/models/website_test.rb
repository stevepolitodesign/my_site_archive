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
  
  test "associated user should have an active subscription or be on a free trial" do
    @unsubscribed_user = users(:unsubscribed_user)
    @website = @unsubscribed_user.websites.build(title: "title", url: "https://www.example.com")
    assert_not @website.valid?

    @user_on_generic_trial = users(:sample_user_on_generic_trial)
    @website = @user_on_generic_trial.websites.build(title: "title", url: "https://www.example.com")
    assert @website.valid?

    @user_on_expired_generic_trial = users(:sample_user_on_expired_generic_trial)
    @website = @user_on_expired_generic_trial.websites.build(title: "title", url: "https://www.example.com")
    assert_not @website.valid?    
  end

  test "should limit the amount of websites a user has based on their plan" do
    @user = users(:subscribed_user_with_no_websites)
    website_limit = @user.current_plan.website_limit 
    website_limit.times do |i|
      @user.websites.create(title: "title", url: "https://www.#{i}.com")
    end
    @website = @user.websites.build(title: "title", url: "https://www.#{website_limit+1}.com")
    assert_not @website.valid?
  end

  test "can belong to an archive" do
    flunk
  end
end
