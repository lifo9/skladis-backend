class AddBarcodeToProduct < ActiveRecord::Migration[7.0]
  def change
    add_reference :products, :barcode, foreign_key: true, index: true
  end
end
