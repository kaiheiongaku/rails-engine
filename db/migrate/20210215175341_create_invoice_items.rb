class CreateInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    create_table :invoice_items, id: false do |t|
      t.integer :id, primary_key: true
      t.references :item, foreign_key: true
      t.references :invoice, foreign_key: true
      t.integer :quantity
      t.float :unit_price
      t.timestamps
    end
  end
end
