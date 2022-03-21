class StockPolicy < ApplicationPolicy
  def index?
    can_manage_stock?
  end

  def show?
    can_manage_stock?
  end

  def stock_in?
    can_manage_stock?
  end

  def stock_out?
    can_manage_stock?
  end

  def stock_transfer?
    can_manage_stock?
  end

  private

  def can_manage_stock?
    user.has_role?(:admin) || user.has_role?(:manager) || user.has_role?(:user)
  end
end
