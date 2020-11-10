class SubscriptionsController < ApplicationController
    before_action :authenticate_user!

    # TODO: Prohibit a user from accessing this route if they have a subscription.
    def new
    end

    def create
        current_user.update(processor: "stripe", card_token: params[:card_token])
        # TODO: Set these values through a Plan model
        current_user.subscribe(name: params[:plan], plan: params[:plan])
        redirect_to root_path, notice: "Subscribed"
        # TODO: Rescue 
    end

    def edit
    end

    def update
    end

    def destroy
    end

end
