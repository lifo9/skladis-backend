class Contact < ApplicationRecord
  include Searchable
  include Orderable
  include Filterable

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_one_attached :avatar do |attachable|
    attachable.variant(:thumb, resize_to_limit: [256, 256])
  end

  after_save_commit :resize_avatar

  PERMITTED_PARAMS = [:first_name, :last_name, :email, :phone, :avatar].freeze

  private

  def resize_avatar
    self.avatar.variant(:thumb).processed if self.avatar.attached?
  end
end
