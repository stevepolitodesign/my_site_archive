class SubscriptionPolicy < ApplicationPolicy
  def new?
    return true unless user_subscribed?
  end

  def edit?
    return true if user_subscribed?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
