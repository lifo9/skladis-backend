class StockTransactionSerializer < ApiSerializer
  attributes :action, :pieces

  belongs_to :user
  belongs_to :stock, meta: proc { |transaction, _|
    {
      product: { id: transaction.stock.product.id, type: Product.to_s.downcase },
      room: { id: transaction.stock.room.id, type: Room.to_s.downcase },
    }
  }
end
