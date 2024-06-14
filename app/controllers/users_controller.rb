class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      respond_to do |format|
        format.html { redirect_to user_path(@user) }
        format.json { render json: { user: @user, token: token }, status: :ok }
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
    begin
      @user = User.find(params[:id])
      Participant.where(user_id: @user.id).destroy_all  
        if @user.destroy
          respond_to do |format|
            format.html { redirect_to root_path }
            format.json { render json: { message: "Successfully deleted the user" }, status: :ok }
          end
        else
          render json: { error: "Could not delete user" }, status: :unprocessable_entity
        end
      rescue StandardError => e
        Rails.logger.warn("Error deleting data: #{e.message}")
      end
    end

  def add_friends
    @user = current_user
    new_friend_id = params[:friend_id].to_i
    @user.friends_id << new_friend_id
    @user.friends_id.uniq!
    if @user.save
      redirect_back fallback_location: user_path(@user), notice: 'Friend added.'
    else
      render json: { error: "Could not add a friend" }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :username, :password, :age, :zipcode, :personality_type, :interests, :is_verified, :bio, :password_confirmation)
  end
end
