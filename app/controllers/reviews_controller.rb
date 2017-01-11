class ReviewsController < ApplicationController


  def new
    p current_user
    p review_params
    @restaurant = Restaurant.find review_params[:restaurant_id]
    @review = @restaurant.build_review review_params, current_user
  end

  def create
    @restaurant = Restaurant.find(params[:restaurant_id])
    @restaurant.reviews.create(review_params)

    if @review.save
      redirect_to restaurants_path
    else
      if @review.errors[:user]
        redirect_to restaurants_path, alert: 'You have already reviewed this restaurant'
      else
        render :new
      end
    end
  end

  private

  def review_params
    p @review
    params.require(:review).permit(:thoughts, :rating)
  end

end
