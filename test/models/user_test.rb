require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.build(
      email: "user@example.com",
      password: "password",
      password_confirmation: "password",
      confirmed_at: Time.zone.now
    )
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "should destroy associated websites" do
    @user.save
    @website = @user.websites.create(title: "title", url: "http://www.example.com")
    assert_difference("Website.count", -1) do
      @user.destroy
    end
  end
end
