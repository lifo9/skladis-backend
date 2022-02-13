class RegistrationInvitation < ApplicationRecord
  self.filter_attributes = [:registration_key, :activation_key]

  validates :registration_key, presence: true
  validates :activation_key, presence: true

  belongs_to :user, required: false, class_name: User.to_s
end
