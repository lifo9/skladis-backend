class OrderItemPolicy < ApplicationPolicy
  def index?
    can_manage_order_item?
  end

  def show?
    can_manage_order_item?
  end

  def create?
    can_manage_order_item?
  end

  def update?
    can_manage_order_item?
  end

  def destroy?
    can_manage_order_item?
  end

  private

  def can_manage_order_item?
    user.has_role?(:admin) || user.has_role?(:manager)
  end
end
