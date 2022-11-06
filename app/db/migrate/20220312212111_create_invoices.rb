class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.string :invoice_code
      t.datetime :invoice_date

      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
