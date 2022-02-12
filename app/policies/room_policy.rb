class RoomPolicy < ApplicationPolicy
  def index?
    can_manage_room?
  end

  def show?
    can_manage_room?
  end

  def create?
    can_manage_room?
  end

  def update?
    can_manage_room?
  end

  def destroy?
    can_manage_room?
  end

  private

  def can_manage_room?
    user.has_role?(:admin) || user.has_role?(:manager)
  end
end
