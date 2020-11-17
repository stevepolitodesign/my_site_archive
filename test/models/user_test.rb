require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      email: "user@example.com",
      password: "password",
      password_confirmation: "password",
      confirmed_at: Time.zone.now
    )
    VCR.insert_cassette name
  end

  def teardown
    VCR.eject_cassette
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "should destroy associated websites" do
    @user = users(:subscribed_user_with_websites)
    count = @user.websites.count
    assert_difference("Website.count", -count) do
      @user.destroy
    end
  end
end
