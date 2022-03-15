class InvoiceItemSerializer < ApiSerializer
  attributes :quantity, :unit_price

  belongs_to :invoice
  belongs_to :product
  belongs_to :supplier
end
