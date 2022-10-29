class AddAttributesToProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :order_code, :string
    add_column :products, :price, :decimal
    add_column :products, :pieces_package, :integer
    add_column :products, :pieces_ideal, :integer
    add_column :products, :pieces_critical, :integer
  end
end
