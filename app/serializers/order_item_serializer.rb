class OrderItemSerializer < ApiSerializer
  attributes :quantity, :unit_price

  belongs_to :order
  belongs_to :product
  belongs_to :supplier
end
