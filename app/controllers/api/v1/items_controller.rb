class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(ItemsFacade.paginate(per_page: params[:per_page], page: params[:page]))
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end
end
