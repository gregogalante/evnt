class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders, id: false do |t|
      t.string :uuid, primary_key: true
      t.string :product_uuid
      t.integer :quantity
      t.float :price_per_piece
    end
  end
end
