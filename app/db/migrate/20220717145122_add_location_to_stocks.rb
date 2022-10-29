class AddLocationToStocks < ActiveRecord::Migration[7.0]
  def change
    add_reference :stocks, :location, null: true, foreign_key: true
  end
end
