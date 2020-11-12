class ResumeSubscriptionsController < ApplicationController
    include Subscribable

    before_action :authenticate_user!
    before_action :set_subscription, only: [:update]

    def update
        current_user.subscription.resume
        redirect_to root_path, notice: "Your subscription has been re-activated."
    rescue Pay::Error
        redirect_to edit_subscription_path, alert: "There was an error resuming your subscription."
    end
end
