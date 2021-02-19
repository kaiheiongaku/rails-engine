class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices

  validates_presence_of :name

  def self.richest_merchants(number_returned)
    self
    .joins(invoices: [:invoice_items, :transactions])
    .where('result = ?', "success")
    .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
    .group(:id)
    .order('total_revenue DESC')
    .limit(number_returned)
  end

  def find_revenue(merchant_id)
    Merchant
    .joins(invoices: [:invoice_items, :transactions])
    .where('result = ?', "success").where('merchants.id = ?', merchant_id)
    .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS total_revenue')
    .group(:id).first.total_revenue
  end
end
