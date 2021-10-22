require 'test_helper'

class RedemptionCodeRegistrationTest < ActionDispatch::IntegrationTest
  setup do
    @redemption_code = redemption_codes(:one)
  end

  test "should grant subscription when registering with a redemption code" do
    assert_no_emails do
      post user_registration_path, params: {
        user: {
          email: "unique-email@example.com",
          password: "password",
          password_confirmation: "password",
          accepted_terms: 1
        },
        redemption_code: @redemption_code.value
      }
    end

    @user = User.find_by(email: "unique-email@example.com")

    assert @user.on_trial?
    assert @user.confirmed?
  end

  test "should handle previously redeemed code" do
    @user = users(:sample_user)
    @redemption = @redemption_code.create_redemption!(user: @user)

    assert_no_difference("User.count") do
      post user_registration_path, params: {
        user: {
          email: "unique-email@example.com",
          password: "password",
          password_confirmation: "password",
          accepted_terms: 1
        },
        redemption_code: @redemption_code.value
      }
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_match "Redemption code has already been taken", @response.body
  end

  test "should conditionally render redemption code field on registration page" do
    get new_user_registration_path
    assert_select "#redemption_code", count: 0

    get new_user_registration_path(params: { enable_redemption_code: "true" })
    assert_select "#redemption_code", count: 1
  end
end
