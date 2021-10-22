require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      email: "user@example.com",
      password: "password",
      password_confirmation: "password",
      confirmed_at: Time.zone.now,
      accepted_terms: true
    )
    VCR.insert_cassette name
  end

  def teardown
    VCR.eject_cassette
  end
  
  test "should be valid" do
    assert @user.valid?
  end

  test "should accept terms" do
    @user.accepted_terms = false
    assert_not @user.valid?
    @user.accepted_terms = nil
    assert_not @user.valid?
  end
  
  test "should destroy associated websites" do
    @user = users(:subscribed_user_with_websites)
    count = @user.websites.count
    assert_difference("Website.count", -count) do
      @user.destroy
    end
  end

  test "should destroy associated archives" do
    assert_difference("Archive.count", -1) do
      users(:guest_user).destroy
    end
  end
  
  test "association with redemptions" do
    @user.save!
    @redemption_code = redemption_codes(:one)

    assert_difference("Redemption.count", 1) do
      @user.create_redemption!(redemption_code: @redemption_code)
    end

    assert_difference("Redemption.count", -1) do
      @user.destroy
    end
  end
end
