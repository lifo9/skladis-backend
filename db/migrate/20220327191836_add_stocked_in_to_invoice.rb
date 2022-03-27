class AddStockedInToInvoice < ActiveRecord::Migration[7.0]
  def change
    add_column :invoices, :stocked_in, :boolean, default: false, null: false
  end
end
