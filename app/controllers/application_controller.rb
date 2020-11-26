class ApplicationController < ActionController::Base
    include Pagy::Backend
    include Pundit

    before_action :authenticate_user!, unless: :exempt_devise_controllers
    before_action :authenticate_subscription, unless: :exempt_subscription_controllers
    after_action :verify_authorized, unless: :exempt_pundit_controllers

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

        def authenticate_subscription
            redirect_to new_subscription_path, alert: "Please subscribe to access this feature." unless current_user.subscribed?
        end

        def credit_cards_controller?
            controller_name == "credit_cards"
        end

        def exempt_devise_controllers
            devise_controller? || static_pages_controller?
        end

        def exempt_subscription_controllers
            devise_controller? || resume_subscriptions_controller? || static_pages_controller? || subscriptions_controller?
        end

        def exempt_pundit_controllers
            credit_cards_controller? || devise_controller? || resume_subscriptions_controller? || static_pages_controller? || subscriptions_controller? || websites_controller?
        end
 
        def resume_subscriptions_controller?
            controller_name == "resume_subscriptions"
        end         
        
        def static_pages_controller?
            controller_name == "static_pages"
        end
        
        def subscriptions_controller?
            controller_name == "subscriptions"
        end
        
        def user_not_authorized
            flash[:alert] = "You are not authorized to perform this action."
            redirect_to(request.referrer || root_path)
        end

        def websites_controller?
            controller_name = "websites" && action_name == "index"
        end
        
end
