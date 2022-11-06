class LocationPolicy < ApplicationPolicy
  def index?
    can_manage_location?
  end

  def show?
    can_manage_location?
  end

  def select_options?
    can_view_location_options?
  end

  def create?
    can_manage_location?
  end

  def update?
    can_manage_location?
  end

  def destroy?
    can_manage_location?
  end

  private

  def can_manage_location?
    user.has_role?(:admin) || user.has_role?(:manager)
  end

  def can_view_location_options?
    true
  end
end
