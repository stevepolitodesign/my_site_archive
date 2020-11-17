class SubscriptionsController < ApplicationController
    include ActionView::Helpers::DateHelper
    include Subscribable

    before_action :authenticate_user!
    before_action :set_subscription, only: [:show, :edit, :update, :destroy]
    before_action :set_available_plans, only: [:edit]
    before_action :set_current_plan, only: [:show, :edit, :update]
    before_action :set_private_plan, only: [:new]

    def show
        authorize @subscription, policy_class: SubscriptionPolicy
        @charges = current_user.charges
    end

    def new
        authorize Pay::Subscription.new, policy_class: SubscriptionPolicy
    end

    def create
        current_user.update(processor: "stripe", card_token: params[:card_token])
        current_user.subscribe(plan: params[:plan], coupon: params[:coupon])
        redirect_to new_website_path, notice: "You are now subscribed."
    rescue Pay::Error
        redirect_to new_subscription_path, alert: "There was an error creating your subscription."
    end

    def edit
        authorize @subscription, policy_class: SubscriptionPolicy
    end

    def update
        current_user.subscription.swap(params[:plan])
        redirect_to root_path, notice: "Your subscription has been updated."
    rescue Pay::Error
        redirect_to edit_subscription_path, alert: "There was an error updating your subscription."
    end

    def destroy
        current_user.subscription.cancel
        redirect_to root_path, notice: "Your subscription has been canceled. You will lose access in #{time_ago_in_words current_user.subscription.ends_at}"
    rescue Pay::Error
        redirect_to subscription_path, alert: "There was an error canceling your subscription."
    end

end
