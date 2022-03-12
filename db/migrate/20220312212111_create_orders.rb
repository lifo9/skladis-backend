class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :order_code

      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
