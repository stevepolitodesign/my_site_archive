require 'test_helper'

class RedemptionCodeRegistrationTest < ActionDispatch::IntegrationTest
  setup do
    @redemption_code = redemption_codes(:one)
  end

  test "should grant subscription when registering with a redemption code" do
    post user_registration_path, params: {
      user: {
        email: "unique-email@example.com",
        password: "password",
        password_confirmation: "password",
        accepted_terms: 1
      },
      redemption_code: @redemption_code.value
    }
    assert User.find_by(email: "unique-email@example.com").on_trial?
  end

  test "should conditionally render redemption code field on registration page" do
    get new_user_registration_path
    assert_select "#redemption_code", count: 0

    get new_user_registration_path(params: { enable_redemption_code: "true" })
    assert_select "#redemption_code", count: 1
  end
end
