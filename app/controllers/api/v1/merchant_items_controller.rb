class Api::V1::MerchantItemsController < ApplicationController
  def index
    render json: MerchantItemsSerializer.new(Merchant.find(params[:merchant_id]).items)
  end
end
