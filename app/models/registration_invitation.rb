class RegistrationInvitation < ApplicationRecord
  validates :key, presence: true
  validates :activation_key, presence: true

  belongs_to :user, required: false
end
