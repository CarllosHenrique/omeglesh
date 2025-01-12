# frozen_string_literal: true

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

  def user_logged_in?
    user.present?
  end

  def redirect_to_new_session
    raise Pundit::NotAuthorizedError, "I18n.t('pundit.errors.unauthenticated')"
  end
end
