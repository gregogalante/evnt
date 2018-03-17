class CreateProducers < ActiveRecord::Migration[5.1]
  def change
    create_table :producers, id: false do |t|
      t.string :uuid, primary_key: true
      t.string :name
    end
  end
end
