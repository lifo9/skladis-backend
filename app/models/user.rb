class User < ApplicationRecord
  rolify
  include Searchable
  include Orderable

  after_create :assign_default_role

  has_secure_password

  validates :email, :uniqueness => { :case_sensitive => false }

  has_one :registration_invitation, dependent: :destroy

  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end
end
