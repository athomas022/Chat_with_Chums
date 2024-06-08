class UsersController < ApplicationController
  devise :database_authenticatable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

   has_secure_password
   
   def update
    @user = User.find(params[:id])
    if @user.valid?
      render json: @user, status: :ok
   else
      render json: { error: 'Failed to update user', errors: @user.errors.full_messages }, 
         status: :unprocessable_entity
   end
    rescue StandardError => e
    Logger.warn("Error updating data: #{e.message}")
  end
       
  def show
    @user = User.find(params[:id])
    # render json: @user
  end

  # def new
  #   @user = User.new
  # end

  def create
    @user = User.new(sign_up_params)
      if @user.save
        token = @user.generate_jwt
        render json: {user: @user, token: token}, status: :created
      else 
        render json: { error: "Could not create a user", errors: @user.errors.full_messages }, status: :unprocessable_entity
        render action: "new"  
      end
    rescue StandardError => e
    Logger.warn("Error creating data: #{e.message}")
  end

 
  # def edit
  # end

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

  end

  private
  def user_params
    params.require(:user).permit(:username, :name, :age, :picture, :zipcode, :personality_type, :interests, :bio)
  end
  def sign_up_params
    params.require(:user).permit(:email, :password)
  end
end
