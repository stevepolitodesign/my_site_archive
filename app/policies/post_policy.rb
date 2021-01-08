class PostPolicy < ApplicationPolicy
  def show?
    record.published? || (user && user.admin?)
  end

  def edit?
    user.admin?
  end

  def update?
    user.admin?
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def destroy?
    user.admin?
  end  

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.published
      end
    end
  end
end
