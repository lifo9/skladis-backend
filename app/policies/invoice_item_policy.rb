class InvoiceItemPolicy < ApplicationPolicy
  def index?
    can_manage_invoice_item?
  end

  def show?
    can_manage_invoice_item?
  end

  def create?
    can_manage_invoice_item?
  end

  def update?
    can_manage_invoice_item?
  end

  def destroy?
    can_manage_invoice_item?
  end

  private

  def can_manage_invoice_item?
    user.has_role?(:admin) || user.has_role?(:manager)
  end
end
