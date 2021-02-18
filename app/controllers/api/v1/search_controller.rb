class Api::V1::SearchController < ApplicationController
  def show
    render json: MerchantSerializer.new(MerchantsFacade.search(params[:name]))
  end
end
