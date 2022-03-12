class ProductPolicy < ApplicationPolicy
  def index?
    can_manage_product?
  end

  def show?
    can_manage_product?
  end

  def create?
    can_manage_product?
  end

  def update?
    can_manage_product?
  end

  def destroy?
    can_manage_product?
  end

  private

  def can_manage_product?
    user.has_role?(:admin) || user.has_role?(:manager)
  end
end
