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

  def all_pieces
    Stock.where(product: self.product).sum(:pieces)
  end

  def pieces_room
    Stock.where(product: self.product, room: self.room).sum(:pieces)
  end

  def pieces_expiration
    Stock.where(product: self.product, expiration: self.expiration).sum(:pieces)
  end
end
