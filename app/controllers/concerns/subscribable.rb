module Subscribable
    extend ActiveSupport::Concern

    included do
        :set_subscription
        :set_available_plans
        :set_current_plan
    end

    private

        def set_subscription
            redirect_to new_subscription_path if current_user.subscription.nil? 
            @subscription = current_user.subscription
        end

        def set_available_plans
            @available_plans = Plan.available.where.not(processor_id: current_user.current_plan.try(:processor_plan))
        end

        def set_current_plan
            @current_plan = current_user.current_plan
        end
end