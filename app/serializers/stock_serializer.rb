class StockSerializer < ApiSerializer
  attributes :expiration, :pieces

  belongs_to :product
  belongs_to :room
  belongs_to :location
end
