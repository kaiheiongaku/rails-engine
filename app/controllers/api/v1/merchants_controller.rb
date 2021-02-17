class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantsFacade.merchant_paginate
  end

  def show
    render json: Merchant.find(params[:id])
  end
end
