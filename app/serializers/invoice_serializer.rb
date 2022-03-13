class InvoiceSerializer < ApiSerializer
  attributes :invoice_code, :invoice_date

  has_many :invoice_items
  belongs_to :user

  attribute :invoice_file do |invoice|
    if invoice.invoice_file.present?
      attachment_url(invoice.invoice_file, 5.minutes)
    end
  end
end
