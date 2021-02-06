class WebpagePolicy < ApplicationPolicy

  def show?
    (user_on_generic_trial? || user_subscribed?) && is_record_owner?
  end

  def new?
    (user_on_generic_trial? || user_subscribed?) && user_has_not_reached_webpage_limit?
  end

  def edit?
    (user_on_generic_trial? || user_subscribed?) && is_record_owner?
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

  private

    def is_record_owner?
      user == record.website.user
    end
end
