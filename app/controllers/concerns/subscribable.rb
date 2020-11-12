module Subscribable
    extend ActiveSupport::Concern

    included do
        :set_subscription
        :set_available_plans
        :set_current_plan
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