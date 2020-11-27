class WebsitePolicy < ApplicationPolicy
  def show?
    user_subscribed? && is_record_owner?
  end
  
  def new?
    user_subscribed? && user_has_not_reached_website_limit?
  end

  def edit?
    user_subscribed? && is_record_owner?
  end

  def create?
    user_subscribed?
  end

  def update?
    user_subscribed? && is_record_owner?
  end

  def destroy?
    user_subscribed? && is_record_owner?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
