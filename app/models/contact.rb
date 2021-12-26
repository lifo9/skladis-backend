class Contact < ApplicationRecord
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  PERMITTED_PARAMS = [:first_name, :last_name, :email, :phone].freeze
end
