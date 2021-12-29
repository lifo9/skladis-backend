class Contact < ApplicationRecord
  include Searchable
  include Orderable

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  PERMITTED_PARAMS = [:first_name, :last_name, :email, :phone].freeze
end
