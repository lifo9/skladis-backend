class RenameBarcodeColumns < ActiveRecord::Migration[7.0]
  def change
    rename_column :barcodes, :type, :barcode_type
    rename_column :barcodes, :code, :barcode_code
  end
end
