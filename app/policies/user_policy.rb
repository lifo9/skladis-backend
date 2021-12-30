class UserPolicy < ApplicationPolicy
  def index?
    user.has_role? :admin
  end
end