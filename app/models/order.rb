class Order < ApplicationRecord
  include Searchable
  include Orderable
  include Filterable

  has_many :order_items, class_name: OrderItem.to_s
  belongs_to :user, class_name: User.to_s

  has_one_attached :invoice

  PERMITTED_PARAMS = [:order_code, :created_at, :invoice, order_items: []].freeze
end
