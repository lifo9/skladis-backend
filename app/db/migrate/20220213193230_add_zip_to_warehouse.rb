class AddZipToWarehouse < ActiveRecord::Migration[7.0]
  def change
    add_column :warehouses, :zip, :string
  end
end
