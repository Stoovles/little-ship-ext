class ItemsController < ApplicationController
  # before_action :determine_scope

  def index
    @items = Item.all.where(enabled: true).order(:item_name)
  end

  def show
    @item = Item.find(params[:id])
    @reviews = @item.reviews.all
  end

  protected

   # def determine_scope
   #   @scope = if request.env['PATH_INFO'] == "/dashboard/items"
   #     Item.merchant_items(current_user)
   #   else
   #     Item.all.where(enabled: true)
   #   end
   # end

end
