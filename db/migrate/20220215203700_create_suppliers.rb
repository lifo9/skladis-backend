class CreateSuppliers < ActiveRecord::Migration[7.0]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :ico
      t.string :dic
      t.string :url
      t.references :address
      t.references :contact
      t.decimal :free_delivery_from
      t.timestamps
    end
  end
end
