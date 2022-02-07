class CreateWarehouses < ActiveRecord::Migration[7.0]
  def change
    create_table :warehouses do |t|
      t.string :name
      t.string :street_name
      t.string :street_number
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
