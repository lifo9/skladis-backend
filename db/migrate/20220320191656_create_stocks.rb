class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.belongs_to :product, null: false, foreign_key: true
      t.belongs_to :room, null: false, foreign_key: true
      t.datetime :expiration, null: false
      t.integer :pieces, null: false
      t.timestamps

      t.index [:product_id, :room_id, :expiration], unique: true
    end
  end
end
