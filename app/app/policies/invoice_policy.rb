class InvoicePolicy < ApplicationPolicy
  def index?
    can_manage_invoice?
  end

  def invoice_date_range?
    can_manage_invoice?
  end

  def show?
    can_manage_invoice?
  end

  def create?
    can_manage_invoice?
  end

  def update?
    can_manage_invoice?
  end

  def update_stocked_in?
    can_manage_invoice?
  end

  def destroy?
    can_manage_invoice?
  end

  private

  def can_manage_invoice?
    user.has_role?(:admin) || user.has_role?(:manager)
  end
end
