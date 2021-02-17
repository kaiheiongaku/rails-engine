class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(MerchantsFacade.paginate(per_page: params[:per_page], page: params[:page]))
  end

  def show
    render json: Merchant.find(params[:id])
  end
end
