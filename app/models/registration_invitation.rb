class RegistrationInvitation < ApplicationRecord
  self.filter_attributes=[:key, :activation_key]

  validates :key, presence: true
  validates :activation_key, presence: true

  belongs_to :user, required: false
end
