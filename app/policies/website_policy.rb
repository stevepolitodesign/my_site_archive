class WebsitePolicy < ApplicationPolicy
  def new?
    user_subscribed?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
