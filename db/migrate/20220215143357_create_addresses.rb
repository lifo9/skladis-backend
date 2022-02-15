class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :street_name
      t.string :street_number
      t.string :city
      t.string :zip
      t.string :country
      t.point :coordinates
      t.timestamps
    end
  end
end
