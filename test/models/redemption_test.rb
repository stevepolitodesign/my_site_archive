require 'test_helper'

class RedemptionTest < ActiveSupport::TestCase
  setup do
    @redemption_code = redemption_codes(:one)
    @user = users(:sample_user)
    @redemption = @redemption_code.build_redemption(user: @user)
  end
  
  test "should be valid" do
    assert @redemption.valid?
  end

  test "should have a user" do
    @redemption.user = nil
    assert_not @redemption.valid?
  end

  test "should have a redemption_code" do
    @redemption.redemption_code = nil
    assert_not @redemption.valid?
  end

  test "should be unique between user and redemption_code" do
    @redemption.save!
    @duplicate_redemption = Redemption.new(user: @redemption.user, redemption_code: @redemption.redemption_code)

    assert_not @duplicate_redemption.valid?
  end
end
