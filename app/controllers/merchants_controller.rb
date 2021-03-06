class MerchantsController < ApplicationController
before_action :require_merchant
skip_before_action :require_merchant, only: [:index]
  def index
    @merchants = User.active_merchant
    @top = User.top_three_merchants_overall
    @fastest = User.three_fastest
    @slowest = User.three_slowest
    @states = User.top_three_states_overall
    @citystates = User.top_three_city_states_overall
    @orders = User.three_biggest_orders
  end

  def show
    @merchant = User.find(current_user.id)
    @items = Item.merchant_items(current_user)
    @orders = @merchant.merchant_pending_orders
    @popular_five = @items.popular_five
    @top_3_states = User.top_three_states(@merchant)
    @top_3_cities = User.top_three_city_states(@merchant)
    @top_user = User.top_user_by_orders(@merchant)
    @top_user_by_items = User.top_user_by_items(@merchant)
    @top_users_by_revenue = User.top_users_by_revenue(@merchant)
  end

  private

  def require_merchant
    render file: "/public/404" unless current_merchant?
  end

end
