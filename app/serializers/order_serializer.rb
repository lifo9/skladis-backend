class OrderSerializer < ApiSerializer
  attributes :order_code, :created_at

  has_many :order_items
  belongs_to :user

  attribute :invoice do |order|
    if order.invoice.present?
      attachment_url(order.invoice, 5.minutes)
    end
  end
end
