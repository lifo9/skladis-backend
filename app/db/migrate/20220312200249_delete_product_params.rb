class DeleteProductParams < ActiveRecord::Migration[7.0]
  def change
    remove_columns :products, :price, :pieces_package
  end
end
