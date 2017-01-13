class RestaurantsController < ApplicationController

  before_action :authenticate_user!, :except =>[:index, :show]

  before_action :require_permission, :only => [:edit, :destroy]

  def require_permission
    if current_user != Restaurant.find(params[:id]).user
      flash[:notice] = 'You must have created this restaurant to do this'
      redirect_to root_path
    end
  end

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def create
    user = current_user
    @restaurant = user.restaurants.create(restaurant_params)
    if @restaurant.save
      redirect_to '/restaurants'
    else
      render 'new'
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    @restaurant.update(restaurant_params)

    redirect_to '/restaurants'
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy
    flash[:notice] = 'Restaurant deleted successfully'
    redirect_to '/restaurants'
  end



  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :description, :image)
  end

end
