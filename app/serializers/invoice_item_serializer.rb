class InvoiceItemSerializer < ApiSerializer
  attributes :quantity, :unit_price

  attribute :invoice_date, if: Proc.new { |_, params|
    params && params[:invoice_date] == true
  }

  belongs_to :invoice
  belongs_to :product
  belongs_to :supplier
end
