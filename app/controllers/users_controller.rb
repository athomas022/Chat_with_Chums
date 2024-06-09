class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  

   def update
    @user = User.find(params[:id])
    if @user.valid?
      render json: @user, status: :ok
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
        token = @user.generate_jwt
        Rails.logger.debug("User saved successfully with ID: #{@user.id}")
        respond_to do |format|
          format.html { redirect_to new_user_path }
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
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      render json: { message: "Successfully deleted the user"}, status: :ok
    else 
      render json: { error: "Could not delete user"}, status: :unprocessable_entity
      #no redirects for the API only rendering JSON
    end
    rescue StandardError => e
    Rails.logger.warn("Error deleting data: #{e.message}")
  end


  private

  def user_params
    params.require(:user).permit(:username, :name, :personality_type,:password)
  end

end
