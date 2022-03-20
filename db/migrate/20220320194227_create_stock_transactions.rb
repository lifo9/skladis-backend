class CreateStockTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :stock_transactions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :stock, foreign_key: true
      t.references :room_from, foreign_key: { to_table: :rooms }
      t.references :room_to, foreign_key: { to_table: :rooms }
      t.string :action, null: false
      t.integer :pieces, null: false

      t.timestamps
    end
  end
end
