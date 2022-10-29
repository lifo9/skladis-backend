class UserPolicy < ApplicationPolicy
  def index?
    user.has_role? :admin
  end

  def select_options?
    user.has_role? :admin
  end

  def show?
    user.has_role? :admin
  end

  def create?
    user.has_role? :admin
  end

  def update?
    user.has_role? :admin
  end

  def destroy?
    user.has_role? :admin
  end

  def destroy_avatar?
    user.has_role? :admin
  end

  def activate?
    user.has_role? :admin
  end

  def deactivate?
    user.has_role? :admin
  end
end