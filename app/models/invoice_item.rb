class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item

  validates_presence_of :invoice_id, :item_id, :quantity, :unit_price
end
