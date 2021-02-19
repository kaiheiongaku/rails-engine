class Api::V1::MerchantRevenuesController < ApplicationController
  def index
    render json: MerchantRevenuesSerializer.new(MerchantsFacade.richest_merchants(params[:quantity]))
  end
end
