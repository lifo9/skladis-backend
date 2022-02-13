class User < ApplicationRecord
  rolify
  include Searchable
  include Orderable

  after_create :assign_default_role
  after_save_commit :resize_avatar

  has_secure_password
  has_one :registration_invitation, dependent: :destroy, class_name: RegistrationInvitation.to_s
  has_one_attached :avatar do |attachable|
    attachable.variant(:thumb, resize_to_limit: [256, 256])
  end

  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  PERMITTED_PARAMS = [:first_name, :last_name, :email, :phone, :password, :avatar, :active, role_ids: []].freeze
  MY_PROFILE_PERMITTED_PARAMS = [:first_name, :last_name, :email, :phone, :password, :avatar].freeze

  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end

  private

  def resize_avatar
    self.avatar.variant(:thumb).processed if self.avatar.attached?
  end
end
