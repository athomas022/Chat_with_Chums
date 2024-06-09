class SessionsController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]
  
  def new
  end
  
  def create
    user = User.find_by_username(sign_in_params[:username])
  
    if user && user.valid_password?(sign_in_params[:password])
      token = generate_jwt(user)
      render json: token.to_json
    else
      render json: { errors: { 'username or password' => ['is invalid'] } }, status: :unprocessable_entity
    end
  end

    def respond_to_on_destroy
      if current_user
        render json: {
          message: "#{current_user.username} has logged out successfully."
        }, status: :ok
      else
        render json: {
          message: "Couldn't find an active session."
        }, status: :unauthorized
      end
    end

  private

  def generate_jwt(user)
    JWT.encode({ id: user.id, exp: 60.days.from_now.to_i }, ENV['DEVISE_JWT_SECRET_KEY'])
  end

  def sign_in_params
    params.require(:user).permit(:username, :password)
  end

end
