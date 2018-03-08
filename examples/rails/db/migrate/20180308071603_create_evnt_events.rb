class CreateEvntEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :evnt_events do |t|
      t.string :name
      t.text :payload

      t.timestamps
    end
  end
end
