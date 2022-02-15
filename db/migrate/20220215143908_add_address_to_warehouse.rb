class AddAddressToWarehouse < ActiveRecord::Migration[7.0]
  def change
    add_reference :warehouses, :address, foreign_key: true, index: true
  end
end
