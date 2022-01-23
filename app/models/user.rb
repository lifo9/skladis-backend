class User < ApplicationRecord
  rolify
  include Searchable
  include Orderable

  after_create :assign_default_role

  has_secure_password
  has_one :registration_invitation, dependent: :destroy

  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end

  PERMITTED_PARAMS = [:first_name, :last_name, :email, :phone, :password, :active, role_ids: []].freeze

  MY_PROFILE_PERMITTED_PARAMS = [:first_name, :last_name, :email, :phone, :password].freeze
end
