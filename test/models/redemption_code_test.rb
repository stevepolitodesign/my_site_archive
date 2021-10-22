require 'test_helper'

class RedemptionCodeTest < ActiveSupport::TestCase
  setup do
    @plan = plans(:monthly_plan)
    @redemption_code = @plan.redemption_codes.build(value: 123)
  end

  test "should be valid" do
    assert @redemption_code.valid?
  end

  test "should have a plan" do
    @redemption_code.plan = nil
    assert_not @redemption_code.valid?
  end

  test "value should be unique" do
    @redemption_code.save!
    @duplicate_redemption_code = @plan.redemption_codes.build(value: @redemption_code.value)

    assert_not @duplicate_redemption_code.valid?
  end

  test "association with redemption" do
    @user = users(:sample_user)
    @redemption_code.save!

    assert_difference("Redemption.count", 1) do
      @redemption_code.create_redemption!(user: @user)
    end

    assert_no_difference("Redemption.count") do
      @redemption_code.destroy
    end

  end
end
