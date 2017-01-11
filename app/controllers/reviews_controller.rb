class ReviewsController < ApplicationController

  before_action :authenticate_user!

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurant = Restaurant.find params[:restaurant_id]
    @review = @restaurant.build_review(review_params, current_user)

    if @review.save
      redirect_to '/restaurants'
    else
      if @review.errors[:user]
        flash[:notice] = 'You have already reviewed thie restaurant'
        redirect_to '/restaurants'
      else
        render :new
      end
    end
  end



  private

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end



end
