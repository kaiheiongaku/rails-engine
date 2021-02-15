class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items, id: false do |t|
      t.integer :id, primary_key: true
      t.string :name
      t.string :description
      t.float :unit_price
      t.references :merchant, foreign_key: true
    end
  end
end
