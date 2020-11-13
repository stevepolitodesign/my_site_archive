require "application_system_test_case"

class SubscriptionFlowsTest < ApplicationSystemTestCase
  # TODO: Test failing payments and/or expired cards
  # TODO: Test expired subscriptions
  def setup
    @unsubscribed_user = users(:unsubscribed_user)
  end

  test "creating a subscription" do
    sign_in @unsubscribed_user
    visit new_subscription_path
    fill_out_subscription_form
    click_button "Save"
    sleep 5
    assert_text "You are now subscribed."
    assert @unsubscribed_user.subscribed?
  end

  test "updating a subscription" do
    skip
  end

  test "deleting a subscription" do
    skip
  end

  test "canceling an account" do
    skip
  end

  test "preventing duplicate subscriptions" do
    skip
  end

  test "updating a card" do
    skip
  end

  test "resuming a subscription" do
    skip
  end
end
