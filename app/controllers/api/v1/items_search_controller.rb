class Api::V1::ItemsSearchController < ApplicationController
  def index
    render json: ItemSerializer.new(ItemsFacade.search(params[:name], params[:min_price], params[:max_price]))
  end
end
