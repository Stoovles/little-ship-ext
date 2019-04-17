class Profile::ReviewsController < ApplicationController
  def index
    @reviews = current_user.reviews
  end

  def create
    @review = Review.new(review_params)
    if @review.save
      item = Item.find(review_params[:item_id])
      order_item = item.order_item_for_item_in_order(params[:review][:order])
      order_item.update(reviewed: true)
      redirect_to profile_reviews_path, success: "Review #{@review.id} has been created"
    else
      redirect_to profile_order_path(params[:review][:order]), danger: "Review was not able to be created - please try again"
    end
  end

  def new
    @review = Review.new
    @item = Item.find(params[:item_id])
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    if @review.update(review_params)
      redirect_to profile_reviews_path, success: "Review #{@review.id} has been updated"
    else
      render :edit
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.delete
    redirect_to profile_reviews_path, danger: "Review #{@review.id} has been deleted"
  end

  private

  def review_params
    params.require(:review).permit(:title,
                                 :description,
                                 :rating,
                                 :item_id).merge(user_id: current_user.id)
  end


end
