require "application_system_test_case"

class SubscriptionFlowsTest < ApplicationSystemTestCase
  # TODO: Test failing payments and/or expired cards
  # TODO: Test expired subscriptions
  def setup
    @unsubscribed_user = users(:unsubscribed_user)
    @subscribed_user = users(:subscribed_user_with_websites)
    @yearly_plan = plans(:yearly_plan)
  end

  test "creating a subscription" do
    create_subscription
    assert_text "You are now subscribed."
    assert @unsubscribed_user.subscribed?
  end

  test "updating a subscription" do
    create_subscription
    visit edit_subscription_path
    click_button @yearly_plan.formatted_name
    sleep 5
    assert_text "Your subscription has been updated."
    assert_equal @yearly_plan.processor_id, @unsubscribed_user.subscription.processor_plan
  end

  test "deleting a subscription" do
    create_subscription
    delete_subscription
    assert_text "Your subscription has been canceled."
    assert @unsubscribed_user.subscription.cancelled?
  end

  test "canceling an account" do
    skip
  end

  test "preventing duplicate subscriptions" do
    sign_in @subscribed_user
    visit new_subscription_path
    assert_text "You are not authorized to perform this action."
  end

  test "updating a card" do
    create_subscription
    visit subscription_path
    fill_out_subscription_form(
      card_number: "5555 5555 5555 4444",
    )
    click_button "Save"
    sleep 5
    assert_text "Credit card updated."
    assert_equal "Mastercard", @unsubscribed_user.reload.card_type
  end

  test "resuming a subscription" do
    create_subscription
    delete_subscription
    visit subscription_path
    click_link "Resume My Subscription"
    sleep 5
    assert_text "Your subscription has been re-activated."
    assert_not @unsubscribed_user.subscription.cancelled?
  end

  private

    def create_subscription
      sign_in @unsubscribed_user
      visit new_subscription_path
      fill_out_subscription_form
      click_button "Save"
      sleep 5
    end

    def delete_subscription
      visit subscription_path
      accept_confirm do
        click_link "Cancel My Subscription"
      end
      sleep 5      
    end
end
