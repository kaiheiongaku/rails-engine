class Api::V1::ItemMerchantController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.find(Item.find(params[:item_id]).merchant_id))
  end
end
