class UpdateUniqueIndexForStockTransaction < ActiveRecord::Migration[7.0]
  def change
    remove_index :stocks, [:product_id, :room_id, :expiration]
    add_index :stocks, [:product_id, :room_id, :location_id, :expiration], name: :idx_stock_unique_idx, unique: true
  end
end
