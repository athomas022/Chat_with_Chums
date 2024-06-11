class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  

   def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      respond_to do |format|
        format.html { redirect_to user_path(@user) }
        format.json { render json: { user: @user, token: token }, status: :ok}
      end
   else
      render json: { error: 'Failed to update user', errors: @user.errors.full_messages }, 
         status: :unprocessable_entity
   end
    rescue StandardError => e
    Rails.logger.warn("Error updating data: #{e.message}")
  end
       
  def show
    @user = User.find(params[:id])
    # render json: @user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    Rails.logger.debug("User params: #{user_params.inspect}")
      if @user.save
        token = User.generate_jwt(@user.username)
        Rails.logger.debug("User saved successfully with ID: #{@user.id}")
        respond_to do |format|
          format.html { redirect_to root_path }
          format.json { render json: { user: @user, token: token }, status: :created }
        end
      else 
        Rails.logger.debug("User save errors: #{@user.errors.full_messages}")
        respond_to do |format|
          format.html { render :new }
          format.json { render json: { error: "Could not create a user", errors: @user.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    rescue StandardError => e
    Rails.logger.warn("Error creating data: #{e.message}")
  end

 
  def edit
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      render json: { message: "Successfully deleted the user"}, status: :ok
    else 
      render json: { error: "Could not delete user"}, status: :unprocessable_entity
    end
    rescue StandardError => e
    Rails.logger.warn("Error deleting data: #{e.message}")
  end


  private

  def user_params
    params.require(:user).permit(:name, :username, :password, :age, :zipcode, :personality_type, :interests, :is_verified, :bio)
  end

end
