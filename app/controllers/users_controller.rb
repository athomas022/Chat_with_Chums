class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    render json: @user
  end

  # def new
  #   @user = User.new
  # end

  def create
    @user = User.new(user_params)
      if @user.save
        render json: @user
      else 
        flash.now[:error] = "Could not save user"
        render action: "new"  
      end
    rescue StandardError => e
    Logger.warn("Error fetching data: #{e.message}")
  end

  def update
    @user = User.find(params[:id])
      if @user.update(user_params)
        render json: @user
      else 
        flash.now[:error] = "Could not update user"
        render action: "edit"  
      end
    rescue StandardError => e
    Logger.warn("Error updating data: #{e.message}")
  end

  # def edit
  # end

  def delete
    @user = User.find(params[:id])
    if @user.destroy(user_params)
      flash[:notification] = "Successfully deleted the user"
      redirect_to root_path
    else 
      flash.now[:error] = "Could not delete user"
      redirect_back(fallback_location: root_path)
    end
    rescue StandardError => e
    Logger.warn("Error updating data: #{e.message}")
  end

  end

  private
  params.require(:user).permit(:username, :name, :age, :picture, :zipcode, :personality_type, :interests, :bio)

end
