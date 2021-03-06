class Invoice < ApplicationRecord
  include Searchable
  include Orderable
  include Filterable

  has_many :invoice_items, dependent: :delete_all, class_name: InvoiceItem.to_s
  belongs_to :user, class_name: User.to_s

  has_one_attached :invoice_file

  validates :invoice_code, uniqueness: true

  PERMITTED_PARAMS = [:invoice_code, :invoice_date, :invoice_file, invoice_items: []].freeze
end
