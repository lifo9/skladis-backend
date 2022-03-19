class InvoiceItem < ApplicationRecord
  include Searchable
  include Orderable
  include Filterable

  belongs_to :invoice, class_name: Invoice.to_s
  belongs_to :product, class_name: Product.to_s
  belongs_to :supplier, class_name: Supplier.to_s

  def invoice_date
    self.invoice.invoice_date
  end

  PERMITTED_PARAMS = [:invoice_id, :product_id, :supplier_id, :quantity, :unit_price].freeze
end
