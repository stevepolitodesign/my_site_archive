class SubscriptionPolicy < ApplicationPolicy
  def show?
    user_subscribed?
  end

  def new?
    user_unsubscribed?
  end

  def edit?
    user_subscribed?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
