require 'test_helper'

class ArchiveTest < ActiveSupport::TestCase
  def setup
    @guest_user = users(:guest_user) 
    @archive    = @guest_user.archives.build(url: "https://www.example.com")
  end

  test "should be valid" do
    assert @archive.valid?
  end

  test "should have a user" do
    @archive.user = nil
    assert_not @archive.valid?
  end

  test "should have a url" do
    @archive.url = nil
    assert_not @archive.valid?
  end

  test "should have a valid url" do
    @archive.url = "foo bar baz"
    assert_not @archive.valid?
  end

  test "user archive limit" do
    @guest_user.archives.destroy_all
    0.upto(Archive::GUEST_USER_LIMIT) do |index|
      @guest_user.archives.create(url: "https://www.example.com")
    end
    assert_not @archive.valid?
  end

  test "should destroy associated website" do
    @archive.save
    @website = @archive.build_website(title: "Some website", url: @archive.url, user: @archive.user)
    @website.save!(validate: false)
    assert_difference("Website.count", -1) do
      @archive.destroy
    end
  end

end
