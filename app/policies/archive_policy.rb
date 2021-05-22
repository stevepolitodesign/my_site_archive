class ArchivePolicy < ApplicationPolicy
  def create?
    return user.archives_count < Archive::GUEST_USER_LIMIT
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
