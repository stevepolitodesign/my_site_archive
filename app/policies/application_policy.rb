class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end

  private

    def is_record_owner?
      user == record.user
    end

    def user_has_not_reached_webpage_limit?
      user.current_plan.webpage_limit > record.website.webpages.count
    end

    def user_has_not_reached_website_limit?
      user.current_plan.website_limit > user.websites.count
    end

    def user_on_generic_trial?
      user.on_generic_trial?
    end

    def user_subscribed?
      user.subscribed?
    end

    def user_unsubscribed?
      !user_subscribed?
    end

end
