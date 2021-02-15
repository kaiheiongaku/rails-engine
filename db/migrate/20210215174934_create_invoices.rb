class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices, id: false do |t|
      t.integer :id, primary_key: true
      t.references :customer, foreign_key: true
      t.references :merchant, foreign_key: true
      t.string :status
      t.timestamps
    end
  end
end
