class WarehousePolicy < ApplicationPolicy
  def index?
    can_manage_warehouse?
  end

  def show?
    can_manage_warehouse?
  end

  def create?
    can_manage_warehouse?
  end

  def update?
    can_manage_warehouse?
  end

  def destroy?
    can_manage_warehouse?
  end

  private

  def can_manage_warehouse?
    user.has_role?(:admin) || user.has_role?(:manager)
  end
end
