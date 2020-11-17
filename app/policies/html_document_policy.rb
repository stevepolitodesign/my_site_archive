class HtmlDocumentPolicy < ApplicationPolicy
  def show?
    user_subscribed? && is_record_owner?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

    def is_record_owner?
      user == record.webpage.website.user
    end
end
