class RegistrationInvitation < ApplicationRecord
  validates :key, presence: true

  belongs_to :user, required: false
end
