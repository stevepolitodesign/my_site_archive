class SubscriptionsController < ApplicationController
    before_action :authenticate_user!

    def new
    end

    def create
        current_user.update(processor: "stripe", card_token: params[:card_token])
        current_user.subscribe(name: "Tier One: Monthly Subscription", plan: "price_1HkrqzIZ6Y8BQ2bm4CJfzmno", )
        redirect_to root_path, notice: "Subscribed"
    end

end
