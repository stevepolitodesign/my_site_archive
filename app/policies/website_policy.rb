class WebsitePolicy < ApplicationPolicy
  def show?
    if record.archive.present?
      return true
    else
      return (user_on_generic_trial? || user_subscribed?) && is_record_owner?
    end
  end
  
  def new?
    (user_on_generic_trial? || user_subscribed?) && user_has_not_reached_website_limit?
  end

  def edit?
    (user_on_generic_trial? || user_subscribed?) && is_record_owner?
  end

  def create?
    (user_on_generic_trial? || user_subscribed?)
  end

  def update?
    (user_on_generic_trial? || user_subscribed?) && is_record_owner?
  end

  def destroy?
    (user_on_generic_trial? || user_subscribed?) && is_record_owner?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
