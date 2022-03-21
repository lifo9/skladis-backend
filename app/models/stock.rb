class Stock < ApplicationRecord
  include Searchable
  include Orderable
  include Filterable

  belongs_to :product, class_name: Product.to_s
  belongs_to :room, class_name: Room.to_s

  validates :product, uniqueness: { scope: [:product, :room, :expiration] }, presence: true
  validates :room, uniqueness: { scope: [:product, :room, :expiration] }, presence: true
  validates :expiration, presence: true
  validates :pieces, comparison: { greater_than_or_equal_to: 0, only_integer: true }, presence: true

  def self.pieces_total(product_id: nil, room_id: nil, expiration: nil)
    query = {}
    query[:product_id] = product_id if product_id.present?
    query[:room_id] = room_id if room_id.present?
    query[:expiration] = expiration if expiration.present?

    Stock.where(query).sum(:pieces)
  end

  PERMITTED_PARAMS_IN_OUT = [:product_id, :expiration, :room_id, :quantity].freeze
  PERMITTED_PARAMS_TRANSFER = [:product_id, :expiration, :room_from_id, :room_to_id, :quantity].freeze
end
