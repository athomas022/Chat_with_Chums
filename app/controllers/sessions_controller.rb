class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]
  before_action :authenticate_user!, only: [:destroy]

  def new
  end

  def create
    Rails.logger.debug "Params received: #{params.inspect}"
    user = User.find_by(username: session_params[:username])
    Rails.logger.debug "User found: #{user.inspect}"

    if user
      Rails.logger.debug "Attempting to authenticate user with password: #{session_params[:password]}"
      if user.authenticate(session_params[:password])
        token = User.generate_jwt(user.username)
        cookies.signed[:jwt_token] = { value: token, httponly: true, secure: Rails.env.production? }
        Rails.logger.debug "Generated JWT Token: #{token}"
        Rails.logger.debug "JWT Token stored in cookies: #{cookies.signed[:jwt_token]}"
        redirect_to user_path(user)
      else
        Rails.logger.debug "Password authentication failed for user: #{session_params[:username]}"
        render json: { errors: { 'username or password' => ['is invalid'] } }, status: :unprocessable_entity
      end
    else
      Rails.logger.debug "User not found with username: #{session_params[:username]}"
      render json: { errors: { 'username or password' => ['is invalid'] } }, status: :unprocessable_entity
    end
  end

  def destroy
    logout_user
    redirect_to root_path, notice: "#{current_user&.username || 'User'} has logged out successfully."
  end

  private

  def logout_user
    reset_session
    cookies.delete(:jwt_token)
  end

  def session_params
    params.require(:session).permit(:username, :password)
  end
end



