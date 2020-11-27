class WebpagePolicy < ApplicationPolicy

  def show?
    user_subscribed? && is_record_owner?
  end

  def new?
    user_subscribed? && user_has_not_reached_webpage_limit?
  end

  def edit?
    user_subscribed? && is_record_owner?
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

  private

    def is_record_owner?
      user == record.website.user
    end
end
