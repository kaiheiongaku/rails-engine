class Api::V1::MerchantItemsController < ApplicationController
  def index
    render json: MerchantItemSerializer.new(Merchant.find(params[:merchant_id]).items)
  end
end
