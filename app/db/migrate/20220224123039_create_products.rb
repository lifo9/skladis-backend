class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name

      t.timestamps
    end

    create_table :products_suppliers, id: false do |t|
      t.belongs_to :product
      t.belongs_to :supplier
    end
  end
end
