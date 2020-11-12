class SubscriptionsController < ApplicationController
    include ActionView::Helpers::DateHelper

    before_action :authenticate_user!
    before_action :set_subscription, only: [:show, :edit, :update, :destroy]
    before_action :set_available_plans, only: [:edit]
    before_action :set_current_plan, only: [:show, :edit, :update]

    def show
    end

    def new
        authorize Pay::Subscription.new, policy_class: SubscriptionPolicy
    end

    def create
        current_user.update(processor: "stripe", card_token: params[:card_token])
        current_user.subscribe(plan: params[:plan])
        redirect_to root_path, notice: "Subscribed"
    rescue Pay::Error
        redirect_to new_subscription_path, notice: "There was an error creating your subscription."
    end

    def edit
        authorize @subscription, policy_class: SubscriptionPolicy
    end

    def update
        current_user.subscription.swap(params[:plan])
        redirect_to root_path, notice: "Your subscription has been updated."
    rescue Pay::Error
        redirect_to edit_subscription_path, notice: "There was an error updating your subscription."
    end

    def destroy
        current_user.subscription.cancel
        redirect_to root_path, notice: "Your subscription has been canceled. You will lose access in #{time_ago_in_words current_user.subscription.ends_at}"
    rescue Pay::Error
        redirect_to subscription_path, notice: "There was an error canceling your subscription."
    end

    private

        def set_subscription
            @subscription = current_user.subscription
        end

        def set_available_plans
            @available_plans = Plan.where.not(processor_id: @subscription.processor_plan)
        end

        def set_current_plan
            @current_plan = Plan.find_by(processor_id: @subscription.processor_plan)
        end

end
