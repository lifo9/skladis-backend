class OrderItem < ApplicationRecord
  include Searchable
  include Orderable
  include Filterable

  belongs_to :order, class_name: Order.to_s
  belongs_to :product, class_name: Product.to_s
  belongs_to :supplier, class_name: Supplier.to_s

  PERMITTED_PARAMS = [:order, :product, :supplier, :quantity, :unit_price].freeze
end
