class SupplierPolicy < ApplicationPolicy
  def index?
    can_manage_supplier?
  end

  def select_options?
    can_manage_supplier?
  end

  def show?
    can_manage_supplier?
  end

  def create?
    can_manage_supplier?
  end

  def update?
    can_manage_supplier?
  end

  def destroy?
    can_manage_supplier?
  end

  private

  def can_manage_supplier?
    user.has_role?(:admin) || user.has_role?(:manager)
  end
end
