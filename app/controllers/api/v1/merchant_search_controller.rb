class Api::V1::MerchantSearchController < ApplicationController
  def show
    render json: MerchantSerializer.new(MerchantsFacade.search(params[:name]))
  end
end
