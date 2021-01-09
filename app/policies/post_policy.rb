class PostPolicy < ApplicationPolicy
  def show?
    record.published? || (user && user.admin?)
  end

  def edit?
    user && user.admin?
  end

  def update?
    user && user.admin?
  end

  def new?
    user && user.admin?
  end

  def create?
    user && user.admin?
  end

  def destroy?
    user && user.admin?
  end  

  class Scope < Scope
    def resolve
      if user && user.admin?
        scope.all
      else
        scope.published
      end
    end
  end
end
