class StockService
  def initialize(user_id:, product_id:, expiration:)
    @user_id = user_id
    @product_id = product_id
    @expiration = expiration
  end

  def stock_in(room_id, quantity)
    stock = Stock.find_by(product_id: @product_id, room_id: room_id, expiration: @expiration)

    ActiveRecord::Base.transaction do
      if stock.present?
        stock.update!(pieces: stock.pieces + quantity)
      else
        stock = Stock.create!(product_id: @product_id, room_id: room_id, expiration: @expiration, pieces: quantity)
      end

      StockTransaction.create!(user_id: @user_id, stock: stock, action: :stock_in, pieces: quantity)
    end
  end

  def stock_out(room_id, quantity)
    stock = Stock.find_by!(product_id: @product_id, room_id: room_id, expiration: @expiration)

    ActiveRecord::Base.transaction do
      stock.update!(pieces: stock.pieces - quantity)

      StockTransaction.create!(user_id: @user_id, stock: stock, action: :stock_out, pieces: quantity)
    end
  end

  def transfer(room_from_id, room_to_id, quantity)
    stock_from = Stock.find_by!(product_id: @product_id, room_id: room_from_id, expiration: @expiration)
    stock_to = Stock.find_by(product_id: @product_id, room_id: room_to_id, expiration: @expiration)

    ActiveRecord::Base.transaction do
      stock_from.update!(pieces: stock_from.pieces - quantity)

      if stock_to.present?
        stock_to.update!(pieces: stock_to.pieces + quantity)
      else
        stock_to = Stock.create!(product_id: @product_id, room_id: room_to_id, expiration: @expiration, pieces: quantity)
      end

      StockTransaction.create!(user_id: @user_id,
                               stock: stock_from,
                               action: :stock_out,
                               pieces: quantity)

      StockTransaction.create!(user_id: @user_id,
                               stock: stock_to,
                               action: :stock_in,
                               pieces: quantity)
    end
  end
end