class OrderPolicy < ApplicationPolicy
  def index?
    can_manage_order?
  end

  def show?
    can_manage_order?
  end

  def create?
    can_manage_order?
  end

  def update?
    can_manage_order?
  end

  def destroy?
    can_manage_order?
  end

  private

  def can_manage_order?
    user.has_role?(:admin) || user.has_role?(:manager)
  end
end
