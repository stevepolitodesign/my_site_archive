require "application_system_test_case"

class SubscriptionFlowsTest < ApplicationSystemTestCase
  # TODO: Test failing payments and/or expired cards
  def setup
    @user_on_generic_trial          = users(:sample_user_on_generic_trial)
    @unsubscribed_user              = users(:unsubscribed_user)
    @subscribed_user                = users(:subscribed_user_with_websites)
    @yearly_plan                    = plans(:yearly_plan)
    @private_plan                   = plans(:private_plan)
  end

  test "creating a subscription" do
    create_subscription
    assert_text "You are now subscribed."
    assert @unsubscribed_user.subscribed?
  end

  test "creating a subscription during a free trial" do
    sign_in @user_on_generic_trial
    visit new_subscription_path
    fill_out_subscription_form
    click_button "Sign Up"
    sleep 10
    assert_text "You are now subscribed."
    assert @user_on_generic_trial.subscribed?
    assert_not @user_on_generic_trial.reload.on_generic_trial?
  end

  test "updating a subscription" do
    create_subscription
    visit edit_subscription_path
    click_button @yearly_plan.formatted_name
    sleep 10
    assert_text "Your subscription has been updated."
    assert_equal @yearly_plan.processor_id, @unsubscribed_user.subscription.processor_plan
  end

  test "deleting a subscription" do
    create_subscription
    pause_subscription
    assert_text "Your subscription has been paused."
    assert @unsubscribed_user.subscription.cancelled?
  end

  test "canceling an account" do
    create_subscription
    visit edit_user_registration_path
    accept_confirm do
      click_button "Cancel my account and subscription"
    end
    sleep 10
    assert_not @unsubscribed_user.subscribed?
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
    click_button "Update My Card"
    sleep 10
    assert_text "Credit card updated."
    assert_equal "Mastercard", @unsubscribed_user.reload.card_type
  end

  test "resuming a subscription" do
    create_subscription
    pause_subscription
    visit subscription_path
    click_link "Resume My Subscription"
    sleep 10
    assert_text "Your subscription has been re-activated."
    assert_not @unsubscribed_user.subscription.cancelled?
  end

  test "hiding private plans on new subscription page" do
    sign_in @unsubscribed_user
    visit new_subscription_path
    assert_text @private_plan.formatted_name, count: 0
    take_screenshot
  end

  test "hiding private plans on the edit subscription plan" do
    create_subscription
    visit edit_subscription_path
    assert_text @private_plan.formatted_name, count: 0
    take_screenshot
  end

  test "subscribing to a private plan" do
    sign_in @unsubscribed_user
    visit new_subscription_path + "?plan_uuid=#{@private_plan.uuid}"
    fill_out_subscription_form
    click_button "Sign Up"
    sleep 10
    assert_text "You are now subscribed."
    assert @unsubscribed_user.subscribed?    
    take_screenshot
  end

  private

    def create_subscription
      sign_in @unsubscribed_user
      visit new_subscription_path
      fill_out_subscription_form
      click_button "Sign Up"
      sleep 10
    end

    def pause_subscription
      visit subscription_path
      accept_confirm do
        click_link "Pause My Subscription"
      end
      sleep 10      
    end
end
