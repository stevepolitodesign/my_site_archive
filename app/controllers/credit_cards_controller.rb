class CreditCardsController < ApplicationController
    def update
        current_user.update_card(params[:card_token])
        redirect_to root_path, notice: "Credit card updated."
    rescue Pay::Error
        redirect_to subscription_path, alert: "There was an error updating your credit card."
    end
end
