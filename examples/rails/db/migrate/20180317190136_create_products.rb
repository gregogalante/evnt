class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products, id: false do |t|
      t.string :uuid, primary_key: true
      t.string :producer_uuid
      t.string :name
      t.integer :quantity_free
      t.integer :quantity_sold
      t.float :price_per_piece
    end
  end
end
