class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(ItemsFacade.paginate(per_page: params[:per_page], page: params[:page]))
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    render json: ItemSerializer.new(Item.create(item_params))
  end

  def update
    render json: ItemSerializer.new(Item.update(item_params))
  end

  private
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end