class SubscriptionsController < ApplicationController
    before_action :authenticate_user!

    def new
        authorize Pay::Subscription.new, policy_class: SubscriptionPolicy
    end

    def create
        current_user.update(processor: "stripe", card_token: params[:card_token])
        # TODO: Set these values through a Plan model
        current_user.subscribe(name: params[:plan], plan: params[:plan])
        redirect_to root_path, notice: "Subscribed"
    rescue Pay::Error
        redirect_to new_subscription_path, notice: "There was an error creating your subscription."
    end

    def edit
        authorize Pay::Subscription.new, policy_class: SubscriptionPolicy
    end

    def update
    end

    def destroy
    end

end
