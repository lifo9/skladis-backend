class MigrateWarehouseAddressToAddress < ActiveRecord::Migration[7.0]
  def change
    warehouses = Warehouse.all
    warehouses.each do |warehouse|
      address = Address.new(
        street_name: warehouse.street_name,
        street_number: warehouse.street_number,
        city: warehouse.city,
        zip: warehouse.zip,
        country: warehouse.country,
        coordinates: warehouse.coordinates
      )
      address.save!
      warehouse.address = address
      warehouse.save!
    end

    remove_columns :warehouses, :street_name, :street_number, :city, :zip, :country, :coordinates
  end
end
