class AddIcDphToSuppliers < ActiveRecord::Migration[7.0]
  def change
    add_column :suppliers, :ic_dph, :string
  end
end
