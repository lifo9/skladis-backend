class AddCoordinatesToWarehouses < ActiveRecord::Migration[7.0]
  def change
    add_column :warehouses, :coordinates, :point
  end
end
