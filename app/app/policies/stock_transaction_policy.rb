class StockTransactionPolicy < ApplicationPolicy
  def index?
    can_manage_stock_transaction?
  end

  def created_at_range?
    can_manage_stock_transaction?
  end

  def show?
    can_manage_stock_transaction?
  end

  private

  def can_manage_stock_transaction?
    user.has_role?(:admin) || user.has_role?(:manager) || user.has_role?(:user)
  end
end
